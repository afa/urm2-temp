#
# This is the JSON-RPC Client, the handler for the client side of a JSON-RPC 
# connection.
#
class JsonRpcClient
  
  require 'net/http'
  require 'uri'
  require 'timeout'  
    
  #
  # Our runtime error classes. Indentation reflects inheritance.
  #
  class Error < RuntimeError; end
    class ServiceError < Error; end
    class ServiceReturnsJunk < Error; end
  
    class RetriableError < Error; end
     class NotAService < Error; end
     class ServiceDown < RetriableError; end
     class ServiceUnavailable < RetriableError; end
     class Timeout < RetriableError; end
       class ServerTimeout < Timeout; end
       class GatewayTimeout < Timeout; end
  
  #
  # Execute this "declaration" with a string or URI object describing the base URI
  # of the JSON-RPC service you want to connect to, e.g. 'http://213.86.231.12/my_services'.
  # NB: avoid DNS host names at all costs, since Net::HTTP can be slow in resolving them.
  # If there is a proxy, pass :proxy => 'http://123.45.32.45:8080' or similar.
  # If you pass :no_auto_config => true, no attempt will be made to contact the service
  # to obtain a description of its available services, which means POST will be used
  # for all requests. This is sometimes useful when a server is non-compliant and does not
  # provide a system.describe call. If you pass :uri_encode_post_bodies => true, all
  # bodies used in POSTs will be URI encoded (fixing a tricky case with UTF-8 characters and
  # non-compliant JSON-RPC servers written in Perl).
  #
  def self.json_rpc_service(base_uri, opts={})
    @uri = URI.parse base_uri
    @host = @uri.host
    @port = @uri.port
    @proxy = opts[:proxy] && URI.parse(opts[:proxy])
    @proxy_host = opts[:proxy] && @proxy.host
    @proxy_port = opts[:proxy] && @proxy.port
    @procs = {}
    @get_procs = []
    @post_procs = []
    @no_auto_config = opts[:no_auto_config]
    @uri_encode_post_bodies = opts[:uri_encode_post_bodies]
    @logger = opts[:debug]
    @retry_strategy = analyze_retry_strategy(opts[:retries])
    @uri
  end
  
  
  def self.analyze_retry_strategy(strat)
    strat ||= 2
    strat = { :max_retries => strat } if strat.kind_of?(Integer)
    { :max_time => nil, 
      :sleep => nil, 
      :sleep_factor => 1.5, 
      :sleep_max => nil 
    }.merge(strat)
  end
  
  
  #
  # Changes the URI for this service. Used in setups where several identical 
  # services can be reached on different hosts.
  #
  def self.set_host(newhost=nil, newport=nil, newproxy=nil)
    @uri.host = @host = newhost if newhost
    @uri.port = @port = newport if newport
    if newproxy
      @proxy = URI.parse(newproxy)
      @proxy_host = @proxy.host
      @proxy_port = @proxy.port
    end
    @uri
  end
  
  
  #
  # This block handler establishes a local scope for a service retry strategy
  #
  def self.retry_strategy(new_strategy)
    old_strategy = @retry_strategy
    @retry_strategy = analyze_retry_strategy(new_strategy)
    yield
  ensure
    @retry_strategy = old_strategy
  end


  #
  # This allows us to call methods remotely with the same syntax as if they were local.
  # If your client object is +service+, you can simply evaluate +service.whatever(:a => 100, :b => [1,2,3])+
  # or whatever you need. Positional and named arguments are fully supported according
  # to the JSON-RPC 1.1 specifications. You can pass a block to each call. If you do,
  # the block will be yielded to using the return value of the call, or, if there is
  # an exception, with the exception itself. This allows you to implement execution 
  # queues or continuation style error handling, amongst other things.
  #
  # DO NOT add more logging to this method for debugging purposes. It slows things down
  # quite considerably.
  #
  def self.method_missing(name, *args)
    system_describe unless (@no_auto_config || @service_description)
    name = name.to_s
    req_wrapper = @get_procs.include?(name) ? Get.new(self, name, args) : 
                                              Post.new(self, name, args, @uri_encode_post_bodies)
    req = req_wrapper.req
    remaining_retries = @retry_strategy[:max_retries]
    started_at = Time.now
    sleep_time = @retry_strategy[:sleep]
    begin
      begin
        Net::HTTP.start(@host, @port, @proxy_host, @proxy_port) do |http|
          res = http.request req
          if res.content_type != 'application/json'
            @logger.debug "JSON-RPC server at #{host_and_port} returned non-JSON data: #{res.body}" if @logger
            raise GatewayTimeout,     "#{res.message} (#{host_and_port})" if res.code == 504 || res.code == "504"
            raise ServiceUnavailable, "#{res.message} (#{host_and_port})" if res.code == 503 || res.code == "503"
            raise NotAService,        "Returned #{res.content_type} (status code #{res.code}: #{res.message}) (#{host_and_port}) rather than application/json"
          end
          json = ActiveSupport::JSON.decode(res.body) rescue raise(ServiceReturnsJunk)
          if json['error']
            @logger.error "JSON-RPC call to #{host_and_port}: #{self}.#{name}(#{args.inspect})" if @logger
            @logger.error "JSON-RPC error from #{host_and_port}: #{json['error'].inspect}" if @logger
            raise ServiceError, "JSON-RPC error from #{host_and_port}: #{json['error'].inspect}"
          end
          return json['result']
        end
      rescue Errno::ECONNREFUSED
        raise ServiceDown, "Connection refused (#{host_and_port})"
      rescue ::Timeout::Error
        raise ServerTimeout, "Server timeout (#{host_and_port})"
      end
    rescue RetriableError => e
      if @retry_strategy[:max_retries]
        remaining_retries -= 1
        raise e if remaining_retries < 0
      end
      if @retry_strategy[:max_time] && (Time.now >= (started_at + @retry_strategy[:max_time]))
        raise e
      end
      if sleep_time
        sleep(sleep_time)
        sleep_time = sleep_time * @retry_strategy[:sleep_factor] if @retry_strategy[:sleep_factor]
        sleep_time = [sleep_time, @retry_strategy[:sleep_max]].min if @retry_strategy[:sleep_max]   
      end
      retry  
    rescue Exception => e
      raise(e)
    end
  end
      

  #
  # The basic path of the service, i.e. '/services'.
  #
  def self.service_path
    @uri.path
  end
  
  
  #
  # The hash of callable remote procs descriptions
  #
  def self.procs
    @procs
  end
  
  #
  # The logger
  #
  def self.logger
    @logger
  end
  
  #
  # Host and port as a string
  #
  def self.host_and_port
    "#{@host}:#{@port}"
  end
      
      
  #
  # This method is called automatically as soon as a client is created. It polls the
  # service for its +system.describe+ information, which the client uses to find out
  # whether to call a remote procedure using GET or POST (depending on idempotency).
  # You can of course use this information in any way you want.
  #
  def self.system_describe
    @service_description = :in_progress
    @service_description = method_missing('system.describe')
    raise "JSON-RPC server (#{host_and_port}) failed to return a service description" unless @service_description
    raise "JSON-RPC server (#{host_and_port}) failed to return a standard-compliant service description" unless @service_description['procs'].kind_of?(Array)
    @service_description['procs'].each do |p|
      @post_procs << p['name']
      @get_procs << p['name'] if p['idempotent']
    end
    @service_description['procs'].each { |p| @procs[p['name']] = p }
    @service_description
  end
      
      
  #
  # This is a simple class wrapper for Net::HTTP::Post and Get objects.
  # They require slightly different initialisation.
  #    
  class Request
    
    attr_reader :req
          
    
    #
    # Sets the HTTP headers required for both GET and POST requests.
    #      
    def initialize
      @req.initialize_http_header 'User-Agent' => 'Ruby JSON-RPC Client 1.1',
                                  'Accept' => 'application/json'
    end
    
  end
  
  
  #
  # GET requests are only made for idempotent procedures, which allows these
  # requests to get cached, etc. (A procedure is declared idempotent on the
  # service side, by specifying :idempotent => true.) GET requests pass all
  # their args in the URI itself, as part of the query string. Positional
  # args are supported, as well as named args. If a call has only a hash
  # as its only argument, the key/val pairs are used as name/value pairs.
  # All other situations pass hashes in their entirety as just one of the args 
  # in the arglist.  
  #
  class Get < Request

    def initialize(klass, name, args)
      if args.length == 0
        query = ''
      elsif args.length == 1 && args[0].is_a?(Hash)
        # If we get an array where the first and only element is a hash, we apply the hash (named args).
        pairs = []
        args[0].each do |key, val|
          pairs << "#{key}=#{URI.encode val.to_s}"
        end
        query = '?' + pairs.join('&')
      else
        pairs = []
        procpar = klass.procs[name]['params']
        args.each_with_index do |val, i|
          key = procpar[i]['name']
          pairs << "#{key}=#{URI.encode val.to_s}"
        end
        query = '?' + pairs.join('&')
      end
      uri = klass.service_path + '/' + name + query
      klass.logger.debug "JSON-RPC GET request to URI #{klass.host_and_port}#{uri}" if klass.logger
      @req = Net::HTTP::Get.new(uri)
      super()
    end

  end
  
  
  #
  # Unless we know that a procedure is idempotent, a POST call will be used.
  # In case anyone wonders, GET and POST requests are roughly of the same
  # speed - GETs require slightly more processing on the client side, while 
  # POSTs require slightly more processing on the service side. Positional
  # args are supported, as well as named args. If a call has only a hash
  # as its only argument, the key/val pairs are used as name/value pairs.
  # All other situations pass hashes in their entirety as just one of the args 
  # in the arglist.
  #
  class Post < Request
    
    def initialize(klass, name, args, uri_encode)
      @req = Net::HTTP::Post.new(klass.service_path)
      super()
      @req.add_field 'Content-Type', 'application/json'
      args = args[0] if args.length == 1 && args[0].is_a?(Hash)
      body = { :version => '1.1', :method => name, :params => args }.to_json
      @req.body = uri_encode ? Post.uri_escape_sanely(body) : body
      klass.logger.debug "JSON-RPC POST request #{uri_encode ? '(with URI encoded body) ' : ''}to URI #{klass.host_and_port}#{klass.service_path} with body #{body}" if klass.logger
    end
    
    
    OUR_UNSAFE = /[^ _\.!~*'()a-zA-Z\d;\/?:@&=+$,{}\"-]/nm unless defined?(OUR_UNSAFE)
 
    def self.uri_escape_sanely(str)
      URI.escape(str, OUR_UNSAFE).gsub('%5B', '[').gsub('%5D', ']')  # Ruby's regexes are BRAIN-DEAD.
    end
    
  end
  
end # of JsonRpcClient

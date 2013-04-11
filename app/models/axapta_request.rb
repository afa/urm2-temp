require 'json_rpc_client'
class AxaptaRequest < JsonRpcClient
 #json_rpc_service 'http://192.168.0.72:20013/jsonrpc2', :no_auto_config => true
 #json_rpc_service 'http://192.168.0.72:20013/jsonrpc', :no_auto_config => true
 # nginx json_rpc_service 'http://172.16.200.40/jsonrpc_test', :no_auto_config => true
 #json_rpc_service 'http://192.168.0.72:7077/', :no_auto_config => true, :uri_encode_post_bodies => true
 json_rpc_service Setting.or_default('sod.host'), :no_auto_config => true#, :uri_encode_post_bodies => true
 #json_rpc_service 'http://172.16.200.40/jsonrpc_debug', :no_auto_config => true#, :uri_encode_post_bodies => true
  def self.method_missing(name, *args)
   begin
    key = "json_rpc-#{Time.now.to_f}"
    strt = Stat::Event.create( :key => key, :name => name, :data => args.to_json){|ev| ev.type = "Stat::Before" }
    rslt, err = super(name, *args)# || [{}, {}]
    Stat::Event.create( :key => key, :name => name, :data => rslt.to_json){|ev| ev.type = "Stat::Done" }
    return rslt, err
   rescue JsonRpcClient::NotAService => e
    Stat::Event.create( :key => key, :name => "JsonRpcClient::NotAService", :data => [e.to_s, e.backtrace].to_json){|ev| ev.type = "Stat::Exception" }
    begin
     strt = Stat::Event.create( :key => key, :name => name, :data => args.to_json){|ev| ev.type = "Stat::Rescue" }
     sleep 1
     rslt, err = super(name, *args)# || [{}, {}]
     Stat::Event.create( :key => key, :name => name, :data => rslt.to_json){|ev| ev.type = "Stat::Done" }
     return rslt, err
    rescue Exception => e
     Stat::Event.create( :key => key, :name => "JsonRpcClient::NotAService", :data => [e.to_s, e.backtrace].to_json){|ev| ev.type = "Stat::Exception" }
     raise
    end
   rescue Exception => e
    Stat::Event.create( :key => key, :name => e.to_s[0..254], :data => [e.to_s, e.backtrace].to_json){|ev| ev.type = "Stat::Exception" }
    raise
   end
  end 
end

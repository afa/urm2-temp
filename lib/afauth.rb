module Afauth
 class AuthError < Exception; end
 module Model
  def self.included(base)
   base.extend ClassMethods
   base.instance_eval do
    before_validation :make_salt, :if => lambda{self.salt.blank?}
    before_validation :calc_password, :on => :create
    before_validation :generate_remember_token, :if => lambda{ self.remember_token.blank? }
    before_save :encrypt_password, :unless => lambda{ self.password.blank? }
   end
  end

  module ClassMethods
   def current=(user)
    @current = user
   end

   def current
    raise AuthError if @current.nil?
    @current
   end

   def post_auth(*list)
    @post_methods ||= []
    @post_methods += list unless list.empty?
   end

   def failed_auth(*list)
    @failed_methods ||= []
    @failed_methods += list unless list.empty?
   end

   def logged?
    not @current.nil?
   end

   def authenticate(username, password)
    unless user = find_by_username(username)
     @failed_methods.each{|m| send(m, nil) } unless @failed_methods.blank?
     raise AuthError
    end
    unless user.authenticated?(password)
     @failed_methods.each{|m| send(m, user) } unless @failed_methods.blank?
     raise AuthError
    end
    @post_methods.each{|m| send(m, user) } unless @post_methods.blank?
    user
   end

   def make_recover_pass
    base62(Digest::MD5.hexdigest([base62(rand(62**8)), Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16), 20)
   end

   def locate_recoverable(email)
   end

   def base62(bin, max_length = 8)
    dig = []
    chrs = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    max_length.times do
     dig << chrs[bin % 62]
     bin /= 62
    end
    dig.map{|i| sprintf("%c", i) }.join
   end

  end

  def authenticated?(pwd)
   self.encrypted_password == self.encrypt(pwd)
  end

  def make_salt
   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, sprintf("%x", rand(2**24))].join) unless self.salt
  end

  def encrypt_password
   self.encrypted_password = self.encrypt(self.password)
  end

  def reset_remember_token!
   self.generate_remember_token
   save(:validate => false)
  end

  def calc_pass
   self.class.base62(Digest::MD5.hexdigest([salt, Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16))
  end

 #protected
  def generate_hash(string)
   if RUBY_VERSION >= '1.9'
    Digest::SHA1.hexdigest(string).encode('UTF-8')
   else
    Digest::SHA1.hexdigest(string)
   end
  end

  def generate_random_code(length = 20)
   if RUBY_VERSION >= '1.9'
    SecureRandom.hex(length).encode('UTF-8')
   else
    SecureRandom.hex(length)
   end
  end

  def encrypt(string)
   generate_hash("--#{self.class.name}--#{salt}--#{string}--")
  end

  def calc_password
   self.password = calc_pass
  end

 end

 module Controller
  module App
   def self.included(base)
    base.extend ClassMethods
    base.instance_eval do
     @auth_model = User if defined?(User)
     @auth_cookie_name = :remember_token
     #@redirect_failed new_session_path
     before_filter :process_cookie
     before_filter :login_from_cookie
     before_filter :authenticate!
     rescue_from Afauth::AuthError do |e|
      if @auth_redirect_on_failed
       redirect_to @auth_redirect_on_failed
      else
       raise
      end
     end


    end
   end

   def sign_out
    if logged_in?
     User.current.settings.update_all("value = '0'", "name = 'hideheader'")
     User.current.reset_remember_token! 
    end
    cookies.delete(:user_remember_token)
    User.current = nil
   end

   def process_cookie
    if cookies[:user_remember_token].blank? || User.where(:remember_token => cookies[:user_remember_token]).first.nil?
     raise Afauth::AuthError
    end
   end

   def user_from_cookie
    token = cookies[:user_remember_token]
    if token
     return nil if token.blank?
     u = User.where(:remember_token => token).first
     #cookies.delete(:user_remember_token) unless u
    end
    u
   end

   def login_from_cookie
    u = user_from_cookie
    if u 
     self.class.user_model.current = u
    end
   end

   def logged_in?
    self.class.user_model.logged?
   end

  def sign_in(user, opts = {})
   if user
    val = {
      :value   => user.remember_token
    }
    val.merge!(:expires => self.class.auth_expired_in.day.from_now.utc) if opts.is_a?(Hash) && opts[:rememberme] && self.class.auth_cookie_name && self.class.auth_expired_in.to_i > 0
    cookies[self.class.auth_cookie_name] = val
    self.class.user_model.current = user
   end
  end

   module ClassMethods
    #setup
    def auth_model(klass)
     @auth_model = klass.is_a?(Class) ? klass : instance_eval(klass.to_s)
    end

    def remembered_cookie_name(name)
     @auth_cookie_name = name
    end

    def redirect_failed(rte)
     @auth_redirect_on_failed = rte
    end

    def auth_expired_in_days(days)
     @auth_expired_in_days = days
    end
    #done

    def user_model
     @auth_model
    end

    def auth_cookie_name
     @auth_cookie_name
    end

    def auth_expired_in
     @auth_expired_in_days
    end
   end
  end

  module Session
  end
 end
end

class User < ActiveRecord::Base

 has_many :accounts
 belongs_to :current_account, :class_name => 'Account'
 belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
 has_many :settings, :as => :settingable
 has_many :children, :class_name => self.name, :foreign_key => :parent_id
 has_many :cart_items
 validates_uniqueness_of :username
 validate :unique_hash, :on => :create
 validate :check_axapta_validity, :on => :create
 before_validation :check_current_account_activity
 attr_accessor :ext_hash, :password
 before_validation :make_salt, :if => lambda{ self.salt.blank? }
 before_validation :calc_password, :on => :create
 after_create :create_axapta_account
 before_validation :generate_remember_token, :if => lambda{ self.remember_token.blank? }
 before_save :encrypt_password, :unless => lambda{ self.password.blank? }

#  def self.authenticate(username, password)
#   return nil  unless user = find_by_name(username)
#   return user if     user.authenticated?(password)
#  end

  #def authenticated?(password)
  # #Digest::MD5.hexdigest([salt, password].join) == encrypted_password
  # encrypt(password) == encrypted_password
  #end
  def self.current=(user)
   @current = user
  end

  def self.current
   @current
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
   if current_account
    axapta_params = Axapta.user_info(current_account.axapta_hash)
    current_account.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless current_account.invent_location_id == axapta_params["invent_location_id"]
   end
   save(:validate => false)
  end


  def accounts_children
   accounts.inject({}){|res, account| res.merge(account.hash => account.children) }
  end

  def axapta_children
   accounts_children.values.flatten.map(&:user).uniq
  end

 def self.authenticate(username, password)
  return nil  unless user = find_by_username(username)
  return nil  if     user.accounts.all.all? {|a| a.blocked? }
  return user if     user.authenticated?(password)
 end

  def self.make_recover_pass
   self.base62(Digest::MD5.hexdigest([self.base62(rand(62**8)), Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16), 20)
  end

  def self.locate_recoverable(email)
   
  end

 #  def authenticated?(password)
 #  Digest::MD5.hexdigest([salt, password].join) == encrypted_password
 # end

  def calc_pass
   User.base62(Digest::MD5.hexdigest([salt, Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16))
  end

  def reload_accounts
   self.accounts.each do |account|
    Axapta.renew_structure(account.axapta_hash)
   end
   if self.current_account
    if self.current_account.blocked?
     self.current_account = nil
     self.save!
    end
   end
  end

  def make_order(dead_line, delivery)
   reqs = cart_items.unprocessed.in_cart.all.partition{|c| c.is_a?(CartRequest) }
   res = []
   unless reqs[1].empty?
    begin
     res << Axapta.make_order(:sales_lines => reqs[1].map{|i| i.to_sales_lines }, :date_dead_line => dead_line, :customer_delivery_type_id => delivery)
     reqs[1].each{|i| i.update_attributes :processed => true, :order => res.last }
    rescue Exception => e
     
    end
   end
   unless reqs[0].empty?
    begin
     res << Axapta.make_order(:sales_lines => reqs[0].map{|i| i.to_sales_lines }, :date_dead_line => dead_line)
     reqs[0].each{|i| i.update_attributes :processed => true, :order => res.last }
    rescue Exception => e
     
    end
   end
   res
  end

  def deliveries
   types = Axapta.get_delivery_mode.try(:[], "customer_delivery_types") || []
   types.map{|t| [t["customer_delivery_type_id"], [t["delivery_type"], t["address"]["city"]].join(' ')] }
  end
 protected
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

  def generate_remember_token
   self.remember_token = generate_random_code
  end

#  def make_salt
#   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, ext_hash].join) unless self.salt
#  end

  def check_axapta_validity
   begin
    axapta_params = Axapta.user_info(ext_hash)
    current_account.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless current_account.invent_location_id == axapta_params["invent_location_id"]
   rescue Exception => e
    errors.add(:ext_hash, "#{e.class.name}:#{e.message}")
   end
  end

  def unique_hash
   errors.add(:ext_hash, "account already exist, try recover password") if Account.find_by_axapta_hash(self.ext_hash)
  end

  def calc_password
   self.password = calc_pass
  end

  def create_axapta_account
   #self.update_attributes :encrypted_password => Digest::MD5.hexdigest([self.salt, self.password].join)
   accounts << Account.create(Axapta.user_info(self.ext_hash).inject({}){|r, a| r.merge(Account.axapta_renames[a[0]].nil? ? {a[0] => a[1]}: {Account.axapta_renames[a[0]] => a[1]}) }.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }.merge({:axapta_hash => self.ext_hash})) if self.accounts.empty?
   #ext_hash = nil
  end

  def self.base62(bin, max_length = 8)
   dig = []
   chrs = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
   max_length.times do
    dig << chrs[bin % 62]
    bin /= 62
   end
   dig.map{|i| sprintf("%c", i) }.join
  end

  def check_current_account_activity
   if current_account.try(:blocked?)
    current_account = nil
   end
  end

end

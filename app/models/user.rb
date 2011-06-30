class User < ActiveRecord::Base

 has_many :accounts
 validates_uniqueness_of :username
 validate :unique_hash, :on => :create
 validate :check_axapta_validity, :on => :create
 attr_accessor :ext_hash, :password
 before_validation :make_salt, :if => lambda{ self.salt.blank? }
 after_create :create_axapta_account
 #include Clearance::User

 #def email_optional?
 #   true
 #end

 def self.authenticate(username, password)
  return nil  unless user = find_by_username(username)
  return user if     user.authenticated?(password)
 end

  def self.make_recover_pass
   self.base62(Digest::MD5.hexdigest([self.base62(rand(62**8)), Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16), 20)
  end

  def self.locate_recoverable(email)
   
  end

  def authenticated?(password)
   Digest::MD5.hexdigest([salt, password].join) == encrypted_password
  end

 protected
  def make_salt
   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, ext_hash].join) unless self.salt
  end

  def check_axapta_validity
   begin
    axapta_params = Axapta.user_info(ext_hash)
    logger.info axapta_params.inspect
   rescue Exception => e
    errors.add(:ext_hash, "#{e.type}:#{e.message}")
   end
  end

  def unique_hash
   errors.add(:ext_hash, "account already exist, try recover password") unless Account.find_by_axapta_hash(self.ext_hash).blank?
  end

  def create_axapta_account
   self.password = calc_pass
   self.update_attributes :encrypted_password => Digest::MD5.hexdigest([self.salt, self.password].join)
   accounts << Account.create(:axapta_hash => self.ext_hash)
   ext_hash = nil
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

  def calc_pass
   User.base62(Digest::MD5.hexdigest([salt, Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s].join).to_i(16))
  end
end

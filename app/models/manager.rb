class Manager < ActiveRecord::Base
 validates_uniqueness_of :name
 before_validation :make_salt, :if => lambda{ self.salt.blank? }
 attr_accessor :password
 before_save :encrypt_password, :unless => lambda{ self.password.blank? }

  def self.authenticate(username, password)
   return nil  unless user = find_by_name(username)
   return user if     user.authenticated?(password)
  end

  def authenticated?(password)
   Digest::MD5.hexdigest([salt, password].join) == encrypted_password
  end

 protected
  def make_salt
   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, sprintf("%x", rand(2**24))].join) unless self.salt
  end

end

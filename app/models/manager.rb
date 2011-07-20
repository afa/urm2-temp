class Manager < ActiveRecord::Base
 validates_uniqueness_of :name
 before_validation :make_salt, :if => lambda{ self.salt.blank? }
 attr_accessor :password
 before_save :encrypt_password, :unless => lambda{ self.password.blank? }

  def self.authenticate(username, password)
   return nil  unless user = find_by_name(username)
   return user if     user.authenticated?(password)
  end

  #def authenticated?(password)
  # #Digest::MD5.hexdigest([salt, password].join) == encrypted_password
  # encrypt(password) == encrypted_password
  #end
  def authenticated?(pwd)
   self.encrypted_password == self.encrypt(pwd)
  end

 protected
  def make_salt
   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, sprintf("%x", rand(2**24))].join) unless self.salt
  end

  def encrypt_password
   self.encrypted_password = self.encrypt(self.password)
   #self.encrypted_password = Digest::MD5.hexdigest([salt, password].join)
  end



    # Set the remember token.
    #
    # @deprecated Use {#reset_remember_token!} instead
    #def remember_me!
    #  warn "[DEPRECATION] remember_me!: use reset_remember_token! instead"
    #  reset_remember_token!
    #end

    # Reset the remember token.
    #
    # @example
    #   user.reset_remember_token!
    def reset_remember_token!
      generate_remember_token
      save(:validate => false)
    end

    # Mark my account as forgotten password.
    #
    # @example
    #   user.forgot_password!
    #def forgot_password!
    #  generate_confirmation_token
    #  save(:validate => false)
    #end

    # Update my password.
    #
    # @return [true, false] password was updated or not
    # @example
    #   user.update_password('new-password')
    def update_password(new_password)
      self.password_changing = true
      self.password          = new_password
      if valid?
        self.confirmation_token = nil
        generate_remember_token
      end
      save
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

end

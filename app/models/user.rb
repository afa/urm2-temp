require "csv"
class User < ActiveRecord::Base

 include Afauth::Model
 post_auth :check_account_vitality
 include Exportable
 has_many :accounts
 belongs_to :current_account, :class_name => 'Account'
 belongs_to :parent, :class_name => self.name, :foreign_key => :parent_id
 has_many :settings, :as => :settingable
 has_many :children, :class_name => self.name, :foreign_key => :parent_id
 has_many :cart_items
 validates :username, :presence => true, :uniqueness => true
 validate :unique_hash, :on => :create
 validate :check_axapta_validity, :on => :create
 before_validation :check_current_account_activity
 attr_accessor :ext_hash, :password
 after_create :create_axapta_account

  def accounts_children
   accounts.inject({}){|res, account| res.merge(account.hash => account.children) }
  end

  def axapta_children
   accounts_children.values.flatten.map(&:user).uniq
  end

  def reload_accounts
   self.accounts.where(:blocked => false).each do |account|
    Account.renew_structure(account.axapta_hash)
   end
   if self.current_account
    if self.current_account.blocked?
     self.current_account = nil
     self.save!
    end
   end
  end

  def make_order(dead_line, delivery, *args)
   #, :order_needed => params[:order_needed], :order_comment => params[:order_comment], :request_comment => params[:request_comment]
   ar = {}.merge(*args) rescue {}
   reqs = cart_items.unprocessed.in_cart.all.partition{|c| c.is_a?(CartRequest) }
   res = [[], nil]
   unless reqs[1].empty?
    ors = []
    reqs[1].map(&:location_link).uniq.compact.sort{|a, b| a == current_account.invent_location_id ? -1 : a <=> b }.each do |loc|
     begin
      clct = reqs[1].select{|c| c.location_link == loc }
      if ar[:sales][loc].blank? || ar[:sales][loc].to_i == 0
       ors << Axapta.make_order(:comment => ar[:order_comment].try(:[], loc), :sales_lines => clct.map(&:to_sales_lines), :date_dead_line => dead_line, :customer_delivery_type_id => delivery).try(:[], "sales_id")
      else
       Axapta.sales_handle_add(:sales_id => ar[:sales][loc], :sales_lines => clct.map(&:to_sales_lines))
       unless ar[:order_comment].try(:[], loc).blank?
        Axapta.sales_handle_header(:sales_id => ar[:sales][loc], :comment => ar[:order_comment][loc])
       end
       ors << ar[:sales][loc]
      end
      clct.each{|i| i.update_attributes :processed => true, :order => ors.last }
      if ar.has_key?(:order_needed) and ar[:order_needed].try[:[], loc] == '1'
       Axapta.create_invoice(ors.last)
      end
     rescue Exception => e
      p "---makeorder_exc!request", e
     end
    end
    res[0] = ors
   end
   unless reqs[0].empty?
    begin
     res[1] = Axapta.create_quotation(:sales_lines => reqs[0].map{|i| i.to_sales_lines }).try(:[], "quotation_id")
     #res << Axapta.make_order(:sales_lines => reqs[0].map{|i| i.to_sales_lines }, :date_dead_line => dead_line).try(:[], "sales_id")
     reqs[0].each{|i| i.update_attributes :processed => true, :order => res.last }
    rescue Exception => e
     p "---createquotation_exc_request", e
    end
   end
   res
  end

  def deliveries
   types = Axapta.get_delivery_mode.try(:[], "customer_delivery_types") || []
   types.map{|t| [t["customer_delivery_type_id"], [t["delivery_type"], t["address"]["city"]].join(' ')] }
  end
 protected
  def generate_remember_token
   self.remember_token = generate_random_code
  end

#  def make_salt
#   self.salt = Digest::MD5.hexdigest([Time.now.strftime("%Y%m%d%H%M%S"), Time.now.usec.to_s, ext_hash].join) unless self.salt
#  end

  def check_axapta_validity
   begin
    axapta_params = Axapta.user_info(ext_hash)
    #TODO: no need check more
    #current_account.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless current_account.invent_location_id == axapta_params["invent_location_id"]
   rescue Exception => e
    errors.add(:ext_hash, "#{e.class.name}:#{Axapta.parse_exc(e.message, e.class.name)[:_error]}")
    p "---e-h", Axapta.parse_exc(e.message, e.class.name)
   end
  end

  def create_axapta_account
   #self.update_attributes :encrypted_password => Digest::MD5.hexdigest([self.salt, self.password].join)
   if self.accounts.empty?
    axapta_params = Axapta.user_info(self.ext_hash)
    acc = Account.create(Axapta.user_info(self.ext_hash).inject({}){|r, a| r.merge(Account.axapta_renames[a[0]].nil? ? {a[0] => a[1]}: {Account.axapta_renames[a[0]] => a[1]}) }.delete_if{|k, v| not Account.axapta_attributes.include?(k.to_s) }.merge({:axapta_hash => self.ext_hash}))
    acc.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless acc.invent_location_id == axapta_params["invent_location_id"]
    accounts << acc
    self.current_account = acc
    save(:validate=>false)
   end
   #ext_hash = nil
  end

  def check_current_account_activity
   if current_account.try(:blocked?)
    current_account = nil
   end
  end

  def unique_hash
   if Account.find_by_axapta_hash(self.ext_hash)
    errors.add(:ext_hash, t(:account_already_exist)) 
    raise Afauth::AuthError
   end
  end

  def self.check_account_vitality(user)
   if user.current_account
    axapta_params = Axapta.user_info(user.current_account.axapta_hash)
    user.current_account.update_attributes :invent_location_id => axapta_params["invent_location_id"] unless user.current_account.invent_location_id == axapta_params["invent_location_id"]
   end
   if user.accounts.all.all? {|a| a.blocked?}
    raise Afauth::AuthError
   end 
  end
end

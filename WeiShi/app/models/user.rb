class User < ActiveRecord::Base

  # create the relation of users roles;
  rolify
  
  belongs_to :category, class_name: "Category", foreign_key: "category_id"
  # configurate the devise;
  devise :database_authenticatable, :rememberable, :trackable, :validatable
         
  # set up the fields;
  attr_accessor :login
  attr_accessible :login, :username, :email, :nickname, :password, :password_confirmation, :legacy_password_hash,
                  :remember_me, :role_ids, :category_id
  validates :username, :presence => true, :uniqueness => { :case_sensitive => false}
  validates :username, :immutable => true
  validates_format_of :username, :with => /^((?! {1,}).)+$/
 # validates :nickname, :presence => true
  validates :email, :uniqueness => true
  validates :email, :immutable => true

  ACCESSABLE_ATTRS = [:login, :username, :email, :nickname, :password, :password_confirmation,
                  :remember_me, :current_password]

  def get_role_names
    NestedResourceHelper.get_nested_resource_list self.roles
  end
  

  # add search methods to support active admin search.
  search_methods :role_ids_eq

  scope :role_ids_eq, lambda { |role_id|
    User.joins(:roles).where("role_id = ?", role_id)
  }

  # support login with user name or email.
  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
  end

  # aims to support the old version system's md5 password.
  def valid_password?(password)
    if self.legacy_password_hash.present?
      if ::Digest::MD5.hexdigest(password).downcase == self.legacy_password_hash
        self.password = password
        self.legacy_password_hash = nil
        self.save(:validates => false)
        true
      else
        false
      end
    else
      super
    end
  end

  def reset_password!(*args)
    self.legacy_password_hash = nil
    super
  end

 def self.tree(category=nil) 
        return scoped unless category
        scoped.includes(:category).where([
          "categories.lft BETWEEN ? AND ?", 
          category.lft, category.rgt
        ])
  end

end

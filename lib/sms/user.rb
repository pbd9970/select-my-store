class SMS::User
  include DB_class
  attr_accessor :first_name, :last_name, :username, :birthday, :sex, :email, :admin, :user_id

  @@unique_val = :username

  def initialize(params)
    params = OpenStruct.new(params)
    @first_name = params[:first_name]
    @last_name  = params[:last_name ]
    @username   = params[:username  ]
    @password   = params[:password  ]
    @birthday   = params[:birthday  ]
    @sex        = params[:sex       ]
    @email      = params[:email     ]
    @admin      = params[:admin     ] || false
    @user_id    = params[:user_id   ]
  end

  def has_password?(password)
    hash_password = Digest::SHA1.hexdigest password
    @password == hash_password
  end

  def update_password(password)
    @password = Digest::SHA1.hexdigest password
    update!(:password)
  end

  def db_map_attrs
    {
      "first_name" => @first_name,
      "last_name"  => @last_name ,
      "username"   => @username  ,
      "password"   => @password  ,
      "birthday"   => @birthday  ,
      "email"      => @email     ,
      "admin"      => @admin     ,
      "sex"        => @sex       ,
    }
  end

  def stores(qualities_array, sex, age)
    qualities_array.map! do |quality_name|
      SMS::Quality.new({name: quality_name}).retrieve!
    end
    qualities_array.map do |quality|
      quality.stores(sex,age)
    end
  end

  def save!
    @password = Digest::SHA1.hexdigest @password
    @user_id = super(:users, db_map, :user_id)
    @user_id.is_a?(self.class) ? @user_id : self
  end

  def update!(db_cols)
    super(:users, {user_id: @user_id}, db_cols)
  end

  def retrieve!
    db_cols = @user_id ? {user_id: @user_id} : db_map(@@unique_val)
    super(:users, self.class, db_cols)
  end

  def delete!
    super(:users, {user_id: @user_id})
  end
end

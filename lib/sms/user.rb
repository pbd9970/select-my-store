class SMS::User < DB_class
  attr_accessor :first_name, :last_name, :username, :birthday, :sex, :email, :admin, :user_id

  def initialize(params)
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

  def db_map(db_cols=nil)
    db_map_attrs = {
      "first_name" => @first_name,
      "last_name"  => @last_name ,
      "username"   => @username  ,
      "password"   => @password  ,
      "birthday"   => @birthday  ,
      "email"      => @email     ,
      "admin"      => @admin     ,
      "sex"        => @sex       ,
    }
    super(db_cols, db_map_attrs)
  end

  def stores(qualities_array)
    qualities_array.map! do |quality_name|
      SMS::Quality.new({name: quality_name}).retrieve!
    end
    qualities_array.map do |quality|
      quality.stores.flatten
    end
  end

  def save!
    @password = Digest::SHA1.hexdigest password
    super(:users, self.class, db_map)
  end

  def update!(db_cols)
    super(:users, self.class, db_cols)
  end

  def retrieve!
    db_cols = db_map.select {|k,value| value }
    super(:users, self.class, db_cols)
  end
end

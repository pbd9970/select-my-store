class Users
  attr_reader :first_name, :last_name, :username, :birthday, :sex, :email, :admin, :user_id

  def initialize(params)
    @first_name = params[:first_name]
    @last_name  = params[:last_name ]
    @username   = params[:username  ]
    @password   = params[:password  ]
    @birthday   = params[:birthday  ]
    @sex        = params[:sex       ]
    @email      = params[:email     ]
    @admin      = params[:admin     ] || false
    @user_id    = params[:user_id   ] || nil
  end

  def has_password?(password)
    password = Digest::SHA1.hexdigest password
    @password == password

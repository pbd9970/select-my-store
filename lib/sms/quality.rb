class Quality < DB_class
  def initialize(params)
    @first_name = params[:first_name]
    @last_name  = params[:last_name ]
    @username   = params[:username  ]
    @password   = params[:password  ]
    @birthday   = params[:birthday  ]
    @sex        = params[:sex       ]
    @email      = params[:email     ]
    @admin      = params[:admin     ] || false

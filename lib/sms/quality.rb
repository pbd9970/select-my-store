class SMS::Quality
  include DB_class
  attr_accessor :name, :male, :female, :quality_id

  @@unique_val = :name

  def initialize(params)
    params = OpenStruct.new(params)
    @name       = params[:name      ]
    @male       = params[:male      ]
    @female     = params[:female    ]
    @quality_id = params[:quality_id] || nil
    @name.downcase!
  end

  def db_map_attrs
    {
      "name"   => @name  ,
      "female" => @female,
      "male"   => @male  ,
    }
  end

  def stores(sex, age)
    return nil if !age.is_a?(Integer) && @quality_id.nil?
    extra_test = "#{age} BETWEEN t1.min_age AND t1.max_age"
    SMS.db.select_join(SMS::Store, :store_id, {sex => true},[:stores,:stores_qualities], extra_test)
  end

  def save!
    @quality_id = super(:qualities, db_map, :quality_id)
    @quality_id.is_a?(self.class) ? @quality_id : self
  end

  def update!(db_cols)
    super(:qualities, self.class, db_cols)
  end

  def retrieve!
    db_cols = @quality_id ? {quality_id: @quality_id} : db_map(@@unique_val)
    super(:qualities, self.class, db_cols)
  end

  def self.available(params)
    db_cols = Hash.new
    db_cols[params[:sex].to_sym] = true
    binding.pry
    SMS.db.select_one(:qualities, self, db_cols) 
  end
end

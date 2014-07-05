class SMS::Quality < SMS::DB_class
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

  def db_map(db_cols=nil)
    db_map_attrs = {
      "name"   => @name  ,
      "female" => @female,
      "male"   => @male  ,
    }
    super(db_cols, db_map_attrs)
  end

  def stores(sex, age)
    return nil unless age.is_a?(Integer)
    return nil if @quality_id == nil
    SMS.db.select_join(SMS::Store, :store_id, {sex => true},[:stores,:stores_qualitites], "#{age} BETWEEN stores.min_age AND stores.max_age")
  end

  def save!
    @quality_id = super(:qualities, db_map, :quality_id)
  end

  def update!(db_cols)
    super(:qualities, self.class, db_cols)
  end

  def retrieve!
    db_cols = @quality_id ? {quality_id: @quality_id} : db_map(@@unique_val)
    super(:qualities, self.class, db_cols)
  end

  def self.qualities(params)
    db_cols = Hash.new
    db_cols[sex.to_sym] = true
    SMS.db.select_one(:qualities, self.class, db_cols) 
  end
end

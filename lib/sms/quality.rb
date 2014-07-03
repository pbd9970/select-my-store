class SMS::Quality < DB_class
  attr_accessor :name, :male, :female, :quality_id

  def initialize(params)
    @name       = params[:name      ]
    @male       = params[:male      ]
    @female     = params[:female    ]
    @quality_id = params[:quality_id] || nil
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
    SMS.db.select_join([:stores,:stores_qualitites], SMS::Store, :store_id, {sex => true},"#{age} BETWEEN stores.min_age AND stores.max_age")
  end

  def save!
    @quality_id = super(:users, self.class, db_map)
  end

  def update!(db_cols)
    super(:users, self.class, db_cols)
  end

  def retrieve!
    db_cols = db_map.select { |k,value| value }
    super(:users, self.class, db_cols)
  end
end

class SMS::Store < SMS::DB_class
  attr_accessor :name, :website, :image_url, :store_id, :min_age, :max_age

  @@unique_val = :name

  def initialize(params)
    @name      = params[:name     ]
    @website   = params[:website  ]
    @image_url = params[:image_url]
    @store_id  = params[:store_id ]
    @min_age   = params[:min_age  ]
    @max_age   = params[:max_age  ]
  end

  def db_map(db_cols=nil)
    db_map_attrs = {
      "name"       => @name,
      "website"    => @website,
      "image_url"  => @image_url,
      "store_id"   => @store_id,
      "min_age"    => @min_age,
      "max_age"    => @max_age
    }
    super(db_cols, db_map_attrs)
  end

  def add_quality(quality, male, female)
    return nil if @store_id.nil?
    quality = SMS::Quality.new({name: quality_name}).retrieve!

    db_map_attrs = {
      "store_id"   => @store_id,
      "quality_id" => quality.quality_id,
      "male"       => male,
      "female"     => female
    }

    SMS.db.insert_into(:stores_qualities, nil, db_map_attrs, [])
  end

  def save!
    @store_id = super(:stores, self.class, db_map, :store_id)
  end

  def update!(db_cols)
    super(:stores, self.class, db_cols)
  end

  def retrieve!
    db_cols = @store_id ? {store_id: @store_id} : db_map(@@unique_val)
    super(:stores, self.class, db_cols)
  end
end

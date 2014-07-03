class SMS::Store < SMS::DB_class
  attr_accessor :name, :website, :image_url, :store_id, :min_age, :max_age

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
      "store_id"   => @store_id
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
    @password = Digest::SHA1.hexdigest password
    super(:users, self.class, db_map)
  end

  def update!(db_cols)
    super(:users, self.class, db_cols)
  end

  def retrieve!
    db_cols = db_map.select { |k,value| value }
    super(:users, self.class, db_cols)
  end
end

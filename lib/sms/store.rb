class SMS::Store
  include DB_class
  attr_accessor :name, :website, :image_url, :store_id, :min_age, :max_age

  @@unique_val = :name

  def initialize(params)
    params = OpenStruct.new(params)
    @name      = params[:name     ]
    @website   = params[:website  ]
    @image_url = params[:image_url]
    @store_id  = params[:store_id ]
    @min_age   = params[:min_age  ]
    @max_age   = params[:max_age  ]
  end

  def db_map_attrs(db_cols=nil)
    {
      "name"       => @name,
      "website"    => @website,
      "image_url"  => @image_url,
      "store_id"   => @store_id,
      "min_age"    => @min_age,
      "max_age"    => @max_age
    }
  end

  def find_qualities(params)
    db_hash = {
      store_id:   @store_id,
      quality_id: params[:quality_id]
    }

    #call the super function of db_map by 
    #reconfiguring all 3 programs to pass the
    #db_map_attrs along.
  end

  def add_quality(params)
    quality_name = params[:name  ]
    male         = params[:male  ]
    female       = params[:female]

    return nil if @store_id.nil?
    quality = SMS::Quality.new({name: quality_name}).retrieve!
    #Check if quality is not set for male/female category
    if quality.male != quality.male || male
      quality.update!({male: male})
    elsif quality.female != quality.female || female
      quality.update!({female: female})
    end

    db_map_attrs = {
      "store_id"   => @store_id,
      "quality_id" => quality.quality_id,
      "male"       => male,
      "female"     => female
    }

    SMS.db.insert_into(:stores_qualities, db_map_attrs)
  end

  def save!
    @store_id = super(:stores, db_map, :store_id)
    @store_id.is_a?(self.class) ? @store_id : self
  end

  def update!(db_cols)
    super(:stores, self.class, db_cols)
  end

  def retrieve!
    db_cols = @store_id ? {store_id: @store_id} : db_map(@@unique_val)
    super(:stores, self.class, db_cols)
  end
end

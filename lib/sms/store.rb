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
    @detail    = params[:detail   ]
  end

  def db_map_attrs(db_cols=nil)
    {
      "name"       => @name,
      "website"    => @website,
      "image_url"  => @image_url,
      "store_id"   => @store_id,
      "min_age"    => @min_age,
      "max_age"    => @max_age,
      "detail"     => @detail
    }
  end

  def add_store_quality(params)
    quality_name = params[:name  ]
    male         = params[:male  ]
    female       = params[:female]

    return nil if @store_id.nil?
    quality = SMS::Quality.new({name: quality_name}).retrieve!
    #Check if quality is not set true for male/female category
    if quality.male != quality.male || male
      quality.male = male
      quality.update!(:male)
    end
    if quality.female != quality.female || female
      quality.female = female
      quality.update!(:female)
    end

    sq = SMS::Store_quality.new({
      :store_id   => @store_id,
      :quality_id => quality.quality_id,
      :male       => male,
      :female     => female
    })

    #save or retrieve from database if exists
    sq = sq.save!

    #overwrite saved db record if entry is different
    unless male.nil?
      if sq.male != male
        sq.male = male
        sq.update!(:male)
      end
    end

    unless female.nil?
      if sq.female != female
        sq.female = female
        sq.update!(:female)
      end
    end
  end

  def save!
    @store_id = super(:stores, db_map, :store_id)
    @store_id.is_a?(self.class) ? @store_id : self
  end

  def update!(db_cols)
    super(:stores, {store_id: @store_id}, db_cols)
  end

  def retrieve!
    db_cols = @store_id ? {store_id: @store_id} : db_map(@@unique_val)
    super(:stores, self.class, db_cols)
  end

  def delete!
    super(:stores, {store_id: @store_id})
  end
end

class SMS::Store_quality
  include DB_class
  attr_accessor :quality_id, :store_id, :male, :female, :id

  @@unique_val = [:quality_id, :store_id]

  def initialize(params)
    params = OpenStruct.new(params)
    @quality_id = params[:quality_id]
    @store_id   = params[:store_id  ]
    @male       = params[:male      ] || false
    @female     = params[:female    ] || false
    @id         = params[:id        ] || nil
  end

  def db_map_attrs
    {
      "quality_id"   => @quality_id,
      "store_id"     => @store_id  ,
      "female"       => @female    ,
      "male"         => @male
    }
  end

  def save!
    @id = super(:stores_qualities, db_map, :id)
    @id.is_a?(self.class) ? @id : self
  end

  def update!(db_cols)
    super(:stores_qualities, {id: @id}, db_cols)
  end

  def retrieve!
    db_cols = @id ? {id: @id} : db_map(@@unique_val)
    super(:stores_qualities, self.class, db_cols)
  end

  def delete!
    super(:stores_qualities, {id: @id})
  end
end


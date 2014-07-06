class SMS::Read_CSV
  def self.stores(filename)
    CSV.foreach(filename, {headers: true}) do |row|
      row_hash = {
        :name            =>    row["STORE NAME"      ],
        :website         =>    row["STORE WEBSITE"   ],
        :image_url       =>    row["STORE IMAGE URL" ],
        :min_age         =>    row["MIN RANGE"       ],
        :max_age         =>    row["MAX RANGE"       ],
        :detail          =>    row["DESCRIPTION"     ]
      }

      store = SMS::Store.new(row_hash)
      store.save!
    end
  end

  def self.store_qualities(filename)
    CSV.foreach(filename, {headers: true}) do |row|

      #add quality if not available, else retrieve quality
      quality = SMS::Quality.new({name: row["QUALITY"]})
      quality = quality.save!

      #retrieve store or raise an error
      store = SMS::Store.new({name: row["STORE NAME"]})
      store = store.retrieve!
      raise NameError, "Invalid store name #{row["STORE NAME"]}" unless store

      store.add_store_quality({:name => quality.name, row["SEX"].to_sym => true})
    end
  end
end

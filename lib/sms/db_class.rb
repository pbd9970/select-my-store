class DB_class
  def db_map(db_cols, db_map_attrs)
    db_cols ||= db_map_attrs.keys
    db_cols = Array.new(1,db_cols) unless db_cols.is_a?(Array)
    db_cols.map! { |val| val.to_s }

    db_map.select { |key,v| db_cols.include?(key) }
  end

  def save!(table)
    SMS.db.create_entry(table, db_map)
  end

  def update!(table, db_cols)
    SMS.db.update_entry(table, db_map(db_cols))
  end

  def retrieve!(table, db_cols)
    SMS.db.retrieve(table, db_hash)
  end
end

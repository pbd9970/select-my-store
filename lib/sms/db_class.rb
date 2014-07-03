class SMS::DB_class
  def db_map(db_cols, db_map_attrs)
    db_cols ||= db_map_attrs.keys
    db_cols = Array.new(1,db_cols) unless db_cols.is_a?(Array)

    db_map_attrs.select { |key,v| (db_cols.include?(key) || db_cols.include?(key.to_sym)) }
  end

  def save!(table, table_class, columns_hash, return_col)
    SMS.db.insert_into(table, table_class, columns_hash, return_col)
  end

  def update!(table, id, cols_hash)
    SMS.db.update(table, db_map(cols_hash))
  end

  def retrieve!(table, table_class, cols_hash, cols_returned_array = ["*"])
    SMS.db.select_one(table, table_class, cols_hash, cols_returned_array = ["*"])
  end
end

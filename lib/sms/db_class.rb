class SMS::DB_class
  def db_join_map
    db_map
  end

  def db_map(db_cols, db_map_attrs)
    return db_map_attrs if db_cols.nil?
    db_cols = [db_cols] unless db_cols.is_a?(Array)

    db_map_attrs.select { |key,v| (db_cols.include?(key) || db_cols.include?(key.to_sym)) }
  end

  def save!(table, columns_hash, return_id)
    check_duplicate = retrieve!
    return check_duplicate if check_duplicate
    SMS.db.insert_into(table, columns_hash, return_id)
  end

  def update!(table, id, cols_array)
    SMS.db.update(table, db_map(cols_array))
  end

  def retrieve!(table, table_class, cols_hash, cols_returned_array = ["*"])
    SMS.db.select_one(table, table_class, cols_hash).first
  end
end

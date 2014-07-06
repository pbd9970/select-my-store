module DB_class
  def db_map_attrs
    raise NotImplementedError
  end

  def db_map(db_cols=nil)
    return db_map_attrs if db_cols.nil?
    db_cols = [db_cols] unless db_cols.is_a?(Array)

    db_map_attrs.select { |key,v| (db_cols.include?(key) || db_cols.include?(key.to_sym)) }
  end

  def save!(table, columns_hash, return_id)
    check_duplicate = retrieve!
    return check_duplicate if check_duplicate
    SMS.db.insert_into(table, columns_hash, return_id)
  end

  def update!(table, id_hash, cols_array)
    SMS.db.update(table, id_hash, db_map(cols_array))
  end

  def retrieve!(table, table_class, cols_hash, cols_returned_array = ["*"])
    SMS.db.select_one(table, table_class, cols_hash).first
  end

  def delete!(table, id_hash)
    SMS.db.delete(table, id_hash)
  end
end

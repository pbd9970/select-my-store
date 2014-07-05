class SMS::DB
  def initialize
    @db = PG.connect(host: 'localhost', dbname: 'SMS')
    #drop_tables
    build_tables
  end

  def build_tables
    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS qualities(
             quality_id SERIAL PRIMARY KEY,
             name TEXT,
             male BOOLEAN,
             female BOOLEAN);])
             #description varchar(140)

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS stores(
             store_id SERIAL PRIMARY KEY,
             name TEXT,
             website TEXT,
             image_url TEXT,
             min_age INTEGER NOT NULL,
             max_age INTEGER NOT NULL);])
             #description varchar(140)

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS stores_qualities(
             id SERIAL PRIMARY KEY,
             store_id INTEGER REFERENCES stores,
             quality_id INTEGER REFERENCES qualities,
             male BOOLEAN,
             female BOOLEAN);])

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS users(
             user_id SERIAL PRIMARY KEY,
             first_name TEXT,
             last_name TEXT,
             username TEXT,
             password TEXT,
             birthday DATE,
             sex TEXT,
             email TEXT,
             admin BOOLEAN);])

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS sessions(
             session_id SERIAL PRIMARY KEY,
             session_key TEXT,
             user_id INTEGER REFERENCES users);])
  end

  def drop_tables
      @db.exec("DROP TABLE IF EXISTS stores_qualities;")
      @db.exec("DROP TABLE IF EXISTS sessions;")
      @db.exec("DROP TABLE IF EXISTS qualities;")
      @db.exec("DROP TABLE IF EXISTS stores;")
      @db.exec("DROP TABLE IF EXISTS users;")
  end

  def select_one(table, return_class, cols_hash)
    
    request = "SELECT * FROM #{table}"
    if cols_hash.empty?
      responses = @db.exec(request + ";")
    else
      params = []
      values = []
      n = 0
      cols_hash.each do |param, value|
        if value.nil?
          params << "#{param} is NULL"
        else
          params << "#{param}=$#{n+=1}"
          values << value
        end
      end

      request += " WHERE " + params.join(" AND ") + ";"
    end
    responses = @db.exec_params(request, values)

    return responses unless responses
    responses.map { |response_params| return_class.__send__(:new, response_params) }
  end

  def insert_into(table, cols_hash, return_col=:id)
    return nil if return_col.to_s.slice(-2,2) != "id" && return_col || cols_hash.empty?
    params = []
    values = []
    cols_hash.each do |param, value|
      next if value.nil?
      params << param
      values << value
    end

    request =  "INSERT INTO #{table} (#{params.join(',')}) "
    request += "VALUES ($#{(1..values.length).map(&:to_s).join(',$')}) "
    request += return_col.nil? ? ";" : "RETURNING #{return_col};" 
      
    responses = @db.exec_params(request, values)

    response = responses.first
    response[return_col.to_s]
  end
  
  def update(table, id, cols_hash = {})
    return nil if cols_hash.empty?
    params = []
    values = []
    n = 0

    cols_hash.each do |param, value|
      next if value.nil?
      params << "#{param}=$#{n+=1}"
      values << value
      end

    values << id

    @db.exec_params("UPDATE #{table} SET #{params.join(',')} WHERE id=$#{n+=1};", values)
  end

  # --- Custom methods ---

  def select_join(return_class, merge_val, check_cols_hash, tables=[:get_vals, :check_vals], extra_tests="")
    return nil if !(tables.is_a? Array) && merge_val.nil? && (check_cols_hash.empty? || extra_tests.empty?)

    request  = "SELECT t1.* FROM #{tables[0]} t1 JOIN #{tables[1]} t2"
    request += " ON t1.#{merge_val}=t2.#{merge_val}"

    params = []
    values = []
    n = 0
    check_cols_hash.each do |param, value|
      if value.nil?
        params << "t2.#{param} is NULL"
      else
        params << "t2.#{param}=$#{n+=1}"
        values << value
      end
    end
    params << extra_tests unless extra_tests.empty?

    request += " WHERE " + params.join(" AND ") + ";"

    responses = @db.exec_params(request, values)
    responses.map { |response_params| return_class.__send__(:new, response_params) }
  end

  def delete(table, id, id_var)
    return nil unless id_var.slice(-3,3) == "_id"

    request =  "DELETE FROM #{table} WHERE #{id_var} = $1;"
    
    @db.exec_params(request, [id])
  end
end

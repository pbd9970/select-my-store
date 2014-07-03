class SMS::DB
  def initialize
    #drop_tables
    build_tables
    @db = PG.connect(host: 'localhost', dbname: 'SMS')
  end

  def build_tables
    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS qualities(
             quality_id SERIAL PRIMARY KEY,
             name TEXT,
             website TEXT,
             image_url TEXT,
             description, varchar(140));])

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS stores(
             store_id SERIAL PRIMARY KEY,
             name TEXT,
             male BOOLEAN,
             female BOOLEAN,
             min_age INTEGER NOT NULL,
             max_age INTEGER NOT NULL,
             description, varchar(140));])

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS stores_qualities(
             id SERIAL PRIMARY KEY,
             quality_id FOREIGN KEY,
             store_id  KEY,
             male BOOLEAN,
             female BOOLEAN,
             description, varchar(140));])

    @db.exec( %Q[
             CREATE TABLE IF NOT EXISTS users(
             id SERIAL PRIMARY KEY,
             store_id REFERENCES stores,
             quality_id REFERENCES qualities,
             male BOOLEAN,
             female BOOLEAN);])
  end

  def select(table, return_class, cols_hash, cols_returned_array = ["*"])
    c = cols_returned_array.join(',')
    request = "SELECT #{c} FROM #{table}"
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

      responses = @db.exec_param(request, values)
    end
    responses.map { |response_params| return_class.__send__(:new, response_params) }
  end

  def insert_into(table, return_class, cols_hash, return_cols=['id'])
    return nil if cols_hash.empty?
    params = []
    values = []
    cols_hash.each do |param, value|
      params << param
      values << value
    end

    params.join(',') 
    values.join(',') 

    request =  "INSERT INTO #{table} (#{params}) "
    request += "VALUES ($#{(1..values.length).map(&:to_s).join(',$')}) "
    request += "RETURNING id;"
      
    responses = @db.exec_params(request, values)

    responses.first[:id]
  end
  
  def update(table, id, cols_hash = {})
    return nil if cols_hash.empty?
    params = []
    values = []
    n = 0

    cols_hash.each do |param, value|
      if valid_params.include? param
        params << "#{param}=$#{n+=1}"
        values << value
      end
    end

    params = params.join(',')
    values << id

    @db.exec_params("UPDATE #{table} SET #{params} WHERE id=$#{n+=1};", values)
  end

  # --- Custom methods ---

  def select_join(return_class, merge_val, check_cols_hash, tables=[:get_vals, :check_vals], extra_tests="")
    return nil if !(tables.is_a? Array) && merge_val.nil? && (check_cols_hash.empty? || extra_tests.empty?)

    request  = "SELECT t1.* #{tables[0]} t1 JOIN #{tables[1]} t2"
    request += "ON t1.#{merge_val}=t2.#{merge_val}"

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

    responses = @db.exec_param(request, values)
    responses.map { |response_params| return_class.__send__(:new, response_params) }
  end
end

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

  def select(table, cols_hash)
    request = "SELECT * FROM projects"
    if cols_hash = {}
      response = @db.exec(request + ";")
    else
      params = []
      values = []
      n = 0
      kwargs.each do |param, value|
        if valid_params.include? param
          params << "#{param}=$#{n+=1}"
          values << value
        end
      end

      return if params == []
      params = params.join(',')
      values << id


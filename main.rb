require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
require 'pg'

def run_query(sql)
  conn = PG.connect(dbname: 'movie_db')
  result = conn.exec(sql)
  conn.close
  return result
end

get '/' do
  erb :index
end

# it gets me the list of the movies with the same keyword
get '/movie_info' do
  url = "http://omdbapi.com/?apikey=2f6435d9&s=#{params[:title]}"
  @movies = HTTParty.get(url)["Search"]
  erb :moviesList
end

# it gives me the page of the movie title i clicked on
get '/movie_info/:id' do
  
  # movie = run_query(sql)
  sql = PG.connect(dbname: 'movie_db')
  results = sql.exec("SELECT * FROM movies WHERE imdbid = '#{params[:id]}';") 

  
  # if movie is in db
  
  if results.count > 0  #exists - read record of database
    
    movie = results[0]   #beacuse results is an array, we return the first element of the array
    @movie_title = movie["name"]
    @movie_year = movie["year"]
    @movie_plot = movie["plot"]
    @movie_image = movie["poster"]
    @movie_imdbID = movie["imdbid"]

  # if movie doesn't exist yet in db
  else  # store in db, HTTParty.get
    url = "http://omdbapi.com/?apikey=2f6435d9&i=#{params[:id]}"
    # create a variable that will give me only the info of the movie I clicked on/e poi toglila per il terzo esercizio perche poi non la andro piu ad usare
    movie = HTTParty.get(url)

    @movie_title = movie["Title"].gsub("'", "")
    @movie_year = movie["Year"]
    @movie_plot = movie["Plot"].gsub("'", "")
    @movie_image = movie["Poster"]
    @movie_imdbID = movie["imdbID"]
    
    sql_str = "INSERT INTO movies(name, year, plot, poster, imdbid) VALUES ('#{@movie_title}', '#{@movie_year}', '#{@movie_plot}', '#{@movie_image}', '#{@movie_imdbID}')"

    # return sql_str
    sql.exec(sql_str)


    # run_query(sql)
  end
    erb :movie
end




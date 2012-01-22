require 'sinatra'
require 'json'
require './make_json'

get '/' do
  if (@i = params[:i]) and (@c = params[:c])
    @l = params[:l]
    @diff = JSON.generate(makeWordDiff(@i, @c))
  end
  erb :index
end

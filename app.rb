require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sqlite3'
require './models.rb'

enable :sessions
set :database, {adapter: 'sqlite3', database: 'mb.sqlite3'}


before do
	current_user
end

before ['/posts/new','/posts','/user/profile'] do
	redirect '/' unless @current_user
end

get '/' do
	@posts = Post.all
	erb :home
end

get '/posts' do
	@posts = Post.all
	erb :posts
end

get '/posts/new' do
	erb :new_post
end

get '/user/edit' do
 	erb :edit_user
end

get '/user/signup' do
  erb :sign_up
end

get '/user/profile' do
	erb :profile
end

# post 'user/profile' do
# 	 @current_user.update({
# 		firstname: params[:firstname],
# 		lastname: params[:lastname],
# 		picture: params[:picture],
# 		bio: params[:bio]
# 	})
#
# 	redirect '/user/profile'
# end

post '/user/signup' do
	user = User.new({
		firstname: params[:firstname],
		lastname: params[:lastname],
		username: params[:username],
		password: params[:password]
	})
	user.save
  redirect '/user/profile'
end

post '/user' do
	puts params
	@current_user.update({
		firstname: params[:firstname],
		lastname: params[:lastname],
		picture: params[:picture],
		bio: params[:bio]
	})

	redirect '/user/profile'
end


post '/posts' do
	post = Post.new({
	create_at: nil,
	content: params[:content],
	content_url: nil,
	rating: nil,
	user_id: @current_user.id,
	})

	post.save
	redirect '/posts'
end


post '/login' do
	user = User.find_by(username: params[:username])
  	if user && user.password == params[:password]

		session[:user_id] = user.id
		flash[:message] = "Welcome"
		redirect '/user/profile'
	else

		flash[:message] = "Incorrect username and/or password. Try again."
		redirect back
	end
end

get '/logout' do
	session[:user_id] = nil
	flash[:message] = "Logged out"
	redirect '/'
end

def current_user
	@current_user = User.find(session[:user_id]) if session[:user_id]
end

require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
require_relative('function.rb')
enable :sessions

get('/') do
    slim(:index)
end

get('/login') do
    slim(:login)
end

post('/login') do
    if login_true(params["username"], params["password"]) == true
        session[:logged_in] = true
        session[:username] = params["username"]
        session[:user_id] = get_user_id(params["username"])
        redirect('/')
    else
        session[:logged_in] = false
        redirect('/')
    end    
end

post('/register') do
    if params["password1"] == params["password2"]
    register(params["username"], params["password1"])
    end
    redirect('/')
end

get('/logout') do
    session.clear
    redirect('/')
end
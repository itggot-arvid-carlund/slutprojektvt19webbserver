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

post('/login') do
    
end

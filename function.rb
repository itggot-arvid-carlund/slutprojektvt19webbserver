require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
enable :sessions

def login_true(username, password)
    db = SQLite3::Database.new("db/db.db")     
    password_hash = db.execute("SELECT users.password_hash FROM users WHERE users.username = ?", username)
    if password_hash.length > 0 && BCrypt::Password.new(password_hash[0][0]).==(password)
        return true
    else
        return false
    end
end

def get_user_id(username)
    db = SQLite3::Database.new("db/db.db")
    user_id = db.execute("SELECT users.user_id FROM users WHERE users.username = ?", username) 
    return user_id
end

def register(username,password)
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO users (username, password_hash) VALUES (?, ?)", username, BCrypt::Password.create(password))
end
require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
enable :sessions

def login_(username, password)
    db = SQLite3::Database.new("db/db.db")     
    password_hash = db.execute("SELECT users.password_hash FROM users WHERE users.username = ?", username)
    if password_hash.length > 0 && BCrypt::Password.new(password_hash[0][0]).==(password)
        return true
    else
        return false
    end
end

def get_userID(username)
    db = SQLite3::Database.new("db/db.db")
    userID = db.execute("SELECT users.userID FROM users WHERE users.username = ?", username) 
    return userID
end

def register(username,password)
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO users (username, password_hash) VALUES (?, ?)", username, BCrypt::Password.create(password))
end

def create_post(title,text)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    time = Time.now.asctime
    db.execute("INSERT INTO posts (title, text, userID, time, upvote_counter) VALUES (?,?,?,?,?)", title, text, session[:userID], time, 0)
end

def get_posts()
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.userID, posts.title, posts.text, posts.time, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID")
    return result
end

def get_1post(id)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.title, posts.text, posts.time, posts.userID, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID WHERE posts.postID = ?", id)
    return result
end

def get_usersposts(id)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.title, posts.text, posts.time, posts.userID, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID WHERE posts.userID = ?", id)
    return result
end

def deletepost(postID)
    db = SQLite3::Database.new("db/db.db")
    db.execute("DELETE FROM posts WHERE postID = ?", postID)
end

def edit_posts(postID, title, text)
    db = SQLite3::Database.new("db/db.db")
    time = Time.now.asctime
    db.execute("UPDATE posts SET title = ?, text = ?, time = ? WHERE postID = ?", title, text, time, postID)
end
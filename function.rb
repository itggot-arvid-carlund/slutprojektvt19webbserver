require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
enable :sessions

 # Finds an article
    #
    # @param [Hash] params form data
    # @option params [String] username The username
    # @option params [String] password The password
    #
    # @return [Integer] The ID of the user
    # @return [false] if credentials do not match a user
def login_(username, password)
    db = SQLite3::Database.new("db/db.db")     
    password_hash = db.execute("SELECT users.password_hash FROM users WHERE users.username = ?", username)
    if password_hash.length > 0 && BCrypt::Password.new(password_hash[0][0]).==(password)
        return true
    else
        return false
    end
end

# Gets a userID from a username by checking database
    #
    # @param [String] username, username
    #
    # @return [Integer] the user id
def get_userID(username)
    db = SQLite3::Database.new("db/db.db")
    userID = db.execute("SELECT users.userID FROM users WHERE users.username = ?", username) 
    return userID
end

def register(username,password)
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO users (username, password_hash) VALUES (?, ?)", username, BCrypt::Password.create(password))
end

# Attempts to create a new post in the posts table
    #
    # @param [String] title, The title of the article
    # @param [String] text, The text of the article
    # @param [Integer] UserID, The Id of the user
    # @param [String] time, The timestamp of the article
    # @param [Integer] upvote_counter, The upvote_counter of the article
    #
def create_post(title,text)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    time = Time.now.asctime
    db.execute("INSERT INTO posts (title, text, userID, time, upvote_counter) VALUES (?,?,?,?,?)", title, text, session[:userID], time, 0)
end

# Gets all posts in database
#
# @return [Hash] returns all posts
def get_posts()
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.userID, posts.title, posts.text, posts.time, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID")
    return result
end

# Gets one posts in database
#
# @return [Hash] returns one posts
def get_1post(id)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.title, posts.text, posts.time, posts.userID, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID WHERE posts.postID = ?", id)
    return result
end

# Gets all users posts in database
#
# @return [Hash] returns users posts
def get_usersposts(id)
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT posts.postID, posts.title, posts.text, posts.time, posts.userID, users.username, posts.upvote_counter FROM posts INNER JOIN users ON users.UserID = posts.userID WHERE posts.userID = ?", id)
    return result
end

# Attempts to delete a post from the post table
    #
    # @param [Integer] postID The post's ID
    # @option params [String] title The title of the post
    # @option params [String] text The text of the post
    #
def deletepost(postID)
    db = SQLite3::Database.new("db/db.db")
    db.execute("DELETE FROM posts WHERE postID = ?", postID)
end

# Attempts to update a post in the posts table
    #
    # @param [Integer] postID The post's ID
    # @option params [String] title The title of the post
    # @option params [String] text The text of the post
    #
def edit_posts(postID, title, text)
    db = SQLite3::Database.new("db/db.db")
    time = Time.now.asctime
    db.execute("UPDATE posts SET title = ?, text = ?, time = ? WHERE postID = ?", title, text, time, postID)
end

def set_error(error_message)
    session[:error] = error_message
end
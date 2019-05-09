require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
require_relative('function.rb')
enable :sessions

# Display Landing Page
#
get('/') do
    slim(:index)
end

# The login page & register page
#
get('/login') do
    slim(:login)
end

# Display the main page after login
#
get('/welcome') do
    if session[:logged_in] == true
        slim(:welcome)
    else
        redirect('/login')
    end
end

# Display all posts
#
get('/post_all') do
    result = get_posts()
    slim(:post_all, locals:{posts: result})
end 

# Attempts to create a post
#
# @see function#blogg_create
get('/blogg_create') do
    if session[:logged_in] == true
        posts = get_usersposts(session[:userID])
        slim(:blogg_create, locals:{
            posts: posts
        })
    else
        redirect('/post_all')
    end
end

# Attempts login and updates the session
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see function#login
post('/login') do
    if login_(params["username"], params["password"]) == true
        session[:logged_in] = true
        session[:username] = params["username"]
        session[:userID] = get_userID(params["username"])
        redirect('/welcome')
    else
        session[:logged_in] = false
        redirect('/')
    end    
end

# Attempts login and updates the session
#
# @param [String] username, The username
# @param [String] password1, The password1
# @param [String] password2, The repeated password
#
# @see function#register
post('/register') do
    if params["password1"] == params["password2"]
    register(params["username"], params["password1"])
    end
    redirect('/')
end

# Creates a new article and redirects to '/welcome'
#
# @param [String] title, The title of the article
# @param [String] content, The content of the article
#
# @see function#create_post
post('/create_post') do
    create_post(params["title"],params["text"])
    redirect('/welcome')
end

# Attempts creating a post
#
# @see function#login
get('/create_post') do
    if session[:logged_in] == true
        slim(:blogg_create)
    else
        redirect('/')
    end
end

# Deletes an existing post and redirects to '/post_all'
#
# @param [Integer] :postID, The ID of the article
#
# @see function#deletepost
post('/deletepost') do
    deletepost(params["postID"])
    redirect('/post_all')
end

# Updates an existing post and redirects to '/post_all'
#
# @param [Integer] :postID, The ID of the post
# @param [String] title, The new title of the post
# @param [String] text, The new text of the post
#
# @see function#edit_post
post('/edit_post') do
    edit_posts(params["postID"], params["title"], params["text"])
    redirect('/post_all')
end

# Edits a single Article
#
# @param [Integer] :id, the ID of the post
# @see function#edit_posts
get('/edit_posts/:id') do 
        result = get_1post(params["id"])
        slim(:post_edit, locals:{
            posts: result[0]} )
end

# Gets a single user
#
# @param [Integer] :id, the ID of the post
# @see function#user
get('/user/:id') do
    posts = get_usersposts(params["id"])
    if posts.length == 0
        redirect('/post_all')
    end
    slim(:user, locals:{
        posts: posts
    })
end

# Logout the user
#
get('/logout') do
    session.clear
    redirect('/')
end
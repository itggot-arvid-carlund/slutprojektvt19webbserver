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

get('/welcome') do
    if session[:logged_in] == true
        slim(:welcome)
    else
        redirect('/login')
    end
end

get('/post_all') do
    result = get_posts()
    slim(:post_all, locals:{posts: result})
end 

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

post('/register') do
    if params["password1"] == params["password2"]
    register(params["username"], params["password1"])
    end
    redirect('/')
end

post('/create_post') do
    create_post(params["title"],params["text"])
    redirect('/welcome')
end

get('/create_post') do
    if session[:logged_in] == true
        slim(:blogg_create)
    else
        redirect('/')
    end
end

post('/deletepost') do
    deletepost(params["postID"])
    redirect('/post_all')
end

post('/edit_post') do
    edit_posts(params["postID"], params["title"], params["text"])
    redirect('/post_all')
end

get('/edit_posts/:id') do 
        result = get_1post(params["id"])
        slim(:post_edit, locals:{
            posts: result[0]} )
end

get('/user/:id') do
    posts = get_usersposts(params["id"])
    if posts.length == 0
        redirect('/post_all')
    end
    slim(:user, locals:{
        posts: posts
    })
end

get('/logout') do
    session.clear
    redirect('/')
end
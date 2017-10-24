# README
## Run step by step ##
```ruby
rake db:create
rake db:migrate
rake db:seed
```

## Username/Password ##
**Username:**  
admin@yahoo.com  
manager@yahoo.com  
customer@yahoo.com  
**Password (all user use same password)**  
12345679//

## Require Login when "New Post" and "Comment on Post" ##
Login with username and password above

## Link ##
Posts:   
https://blog-nam.herokuapp.com/  
Comment on Post (click to show)  
https://blog-nam.herokuapp.com/posts/16  
SignIn(Click on Sign In on navigation bar)  
https://blog-nam.herokuapp.com/users/sign_in

### Sort Post click Button Asc and Desc right of title Post ###


## Provides a RESTful API for retrieve posts ##
List Post  
https://blog-nam.herokuapp.com/api/v1/posts  
Search Post on FullTextSearch  
https://blog-nam.herokuapp.com/api/v1/posts/search?term=Veniam%20adipisci  

## GitHub ##
https://github.com/cavoixanha/blog

## Heroku ##
https://blog-nam.herokuapp.com

## Gem Use ##
```ruby
gem 'devise'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# UI
gem 'simple_form'
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails", '3.2.2'
# gem 'bootstrap-sass', '~> 3.3.6'
gem 'haml-rails'
gem 'kaminari'
# gem 'kaminari_themes', :git => 'https://github.com/amatsuda/kaminari_themes.git'

gem "pundit"
gem "pg_search"
gem 'faker'

group :development, :test do
  # If you use gems that require environment variables to be set before they are loaded,
  # then list dotenv-rails in the Gemfile before those other gems and require dotenv/rails-now.
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'capistrano-env-config'
end
```

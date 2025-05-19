class ShortenedUrlsController < ApplicationController
  #Step 1 

  
  #  @@urls_map = {}
  # @@id = 1



  # def shorten
  #   @@urls_map[@@id.to_i] = {long_url: params[:url], short_url: "http://rashmi.net/#{@@id}"}
  #   @@id += 1
      
  #   render json: {status: 'ok', message: @@urls_map}
  # end

  # def redirect
  #   render json: {message: @@urls_map[params[:id].to_i]}
  # end



  #Analysis of Step 1 with 100 users
#   Started POST "/shorten" for 127.0.0.1 at 2025-05-19 11:07:31 +0530
# Processing by ShortenedUrlsController#shorten as */*
#   Parameters: {"url"=>"https://example99.com"}
# Can't verify CSRF token authenticity.
# Completed 200 OK in 6ms (Views: 4.9ms | ActiveRecord: 0.0ms | Allocations: 3120)


#   Started GET "/redirect/100" 
# Processing by ShortenedUrlsController#redirect as HTML
#   Parameters: {"id"=>"100"}
# Completed 200 OK in 2ms (Views: 0.5ms | ActiveRecord: 0.0ms | Allocations: 219)


# -------------With 1000 users system crashed-----------------


#=====================================
  #Step 2 Use a database
#======================================
  before_action :set_urls

  def shorten
    id = (ShortenedUrl.last&.id || 0) + 1
    new_url = ShortenedUrl.create(long_url: params[:url], short_url: "http://rashmi.net/#{id}")
    
    if new_url.persisted?
      render json: {status: 'ok', message: new_url}
    else
      render json: {status: new_url.errors, message: 'error'}
    end
  end

  def redirect
    url = ShortenedUrl.find(params[:id])
    render json: url 
  end

  def set_urls
    @id ||= 1
    @urls_map ||= {}
  end
end

#Analysis of Step 2 with 100 users 
# Started POST "/shorten" for 127.0.0.1 at 2025-05-19 11:09:18 +0530
# Processing by ShortenedUrlsController#shorten as */*
#   Parameters: {"url"=>"https://example100.com"}
# Can't verify CSRF token authenticity.
#   ShortenedUrl Load (0.2ms)  SELECT "shortened_urls".* FROM "shortened_urls" ORDER BY "shortened_urls"."id" DESC LIMIT ?  [["LIMIT", 1]]
#   ↳ app/controllers/shortened_urls_controller.rb:44:in `shorten'
#   TRANSACTION (0.1ms)  begin transaction
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
#   ShortenedUrl Create (0.7ms)  INSERT INTO "shortened_urls" ("long_url", "short_url", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["long_url", "https://example100.com"], ["short_url", "http://rashmi.net/100"], ["created_at", "2025-05-19 05:39:18.149276"], ["updated_at", "2025-05-19 05:39:18.149276"]]
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
#   TRANSACTION (23.4ms)  commit transaction
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
# Completed 200 OK in 46ms (Views: 0.5ms | ActiveRecord: 24.4ms | Allocations: 4094)

# Processing by ShortenedUrlsController#redirect as HTML
#   Parameters: {"id"=>"100"}
# /home/rashmi/.rbenv/versions/2.7.4/lib/ruby/gems/2.7.0/gems/sqlite3-1.4.0/lib/sqlite3/database.rb:89: warning: rb_check_safe_obj will be removed in Ruby 3.0
#    (0.3ms)  SELECT sqlite_version(*)
#   ↳ app/controllers/shortened_urls_controller.rb:55:in `redirect'
#   ShortenedUrl Load (0.3ms)  SELECT "shortened_urls".* FROM "shortened_urls" WHERE "shortened_urls"."id" = ? LIMIT ?  [["id", 100], ["LIMIT", 1]]
#   ↳ app/controllers/shortened_urls_controller.rb:55:in `redirect'
# Completed 200 OK in 24ms (Views: 1.1ms | ActiveRecord: 2.5ms | Allocations: 4207)

#------------------With 1000 users---------------------
# Started POST "/shorten" for 127.0.0.1 at 2025-05-19 11:55:34 +0530
# Processing by ShortenedUrlsController#shorten as */*
#   Parameters: {"url"=>"https://example1000.com"}
# Can't verify CSRF token authenticity.
#   ShortenedUrl Load (0.1ms)  SELECT "shortened_urls".* FROM "shortened_urls" ORDER BY "shortened_urls"."id" DESC LIMIT ?  [["LIMIT", 1]]
#   ↳ app/controllers/shortened_urls_controller.rb:44:in `shorten'
#   TRANSACTION (0.2ms)  begin transaction
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
#   ShortenedUrl Create (0.4ms)  INSERT INTO "shortened_urls" ("long_url", "short_url", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["long_url", "https://example1000.com"], ["short_url", "http://rashmi.net/1000"], ["created_at", "2025-05-19 06:25:34.352055"], ["updated_at", "2025-05-19 06:25:34.352055"]]
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
#   TRANSACTION (3.3ms)  commit transaction
#   ↳ app/controllers/shortened_urls_controller.rb:45:in `shorten'
# Completed 200 OK in 15ms (Views: 0.5ms | ActiveRecord: 4.1ms | Allocations: 4518)

# Started GET "/redirect/100" for ::1 at 2025-05-19 11:57:06 +0530
# Processing by ShortenedUrlsController#redirect as HTML
#   Parameters: {"id"=>"100"}
# /home/rashmi/.rbenv/versions/2.7.4/lib/ruby/gems/2.7.0/gems/sqlite3-1.4.0/lib/sqlite3/database.rb:89: warning: rb_check_safe_obj will be removed in Ruby 3.0
#    (0.1ms)  SELECT sqlite_version(*)
#   ↳ app/controllers/shortened_urls_controller.rb:57:in `redirect'
#   ShortenedUrl Load (0.1ms)  SELECT "shortened_urls".* FROM "shortened_urls" WHERE "shortened_urls"."id" = ? LIMIT ?  [["id", 100], ["LIMIT", 1]]
#   ↳ app/controllers/shortened_urls_controller.rb:57:in `redirect'
# Completed 200 OK in 10ms (Views: 0.6ms | ActiveRecord: 0.9ms | Allocations: 4479)




#Step 3 Caching


#------------------------------------------------------
# ruby lib/tasks/api_calls.rb

# rails db:migrate:reset

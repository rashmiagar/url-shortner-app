require 'net/http'
require 'uri'
id = 1
url = URI.parse('http://localhost:3001/shorten')


1000.times {
  params = { url: "https://example#{id}.com" }
  response = Net::HTTP.post_form(url, params)
  id += 1
  puts "Response code: #{response.code}"
  puts "Response body: #{response.body}"
}
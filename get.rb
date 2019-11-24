require "date"
require "json"
require "net/http"
require "uri"

token = ENV["TOKEN"]
query = File.read("./query.graphql")

uri = URI.parse("https://api.github.com/graphql")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri)

request["Content-Type"] = "application/json"
request["Authorization"] = "bearer #{token}"
request.body = JSON.dump({ query: query })

response = http.request(request)

if response.code != "200"
  p response.code
  p response.body
  exit 1
end

data = JSON.parse(response.body)["data"]["repository"]["issues"]["nodes"]

records = data.each_with_object([]) do |ha, ret|
  labels = ha["labels"]["nodes"].map { |h| h["name"] }.sort
  next if labels.empty?

  title, url = ha.values_at("title", "url")

  ret << {
    title: title,
    start_date: labels.first.split(".").map(&:to_i) + [1],
    end_date: labels.first.split(".").map(&:to_i) + [1],
    url: url
  }
end

puts "--> Sample"
puts records.first(3)

File.write("data.json", JSON.dump(records))

puts "--> Write to data.json"

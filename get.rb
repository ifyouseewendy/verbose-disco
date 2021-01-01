require 'date'
require 'json'
require 'net/http'
require 'uri'

token = ENV['TOKEN']
query = File.read('./query.graphql')

uri = URI.parse('https://api.github.com/graphql')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri)

request['Content-Type'] = 'application/json'
request['Authorization'] = "bearer #{token}"
request.body = JSON.dump({ query: query })

response = http.request(request)

if response.code != '200'
  p response.code
  p response.body
  exit 1
end

nodes = JSON.parse(response.body)['data']['repository']['issues']['nodes']
issues = nodes.each_with_object([]) do |ha, ret|
  labels = ha['labels']['nodes'].map { |h| h['name'] }.sort
  next if labels.empty?
  next if labels.include?('wontfix')

  labels = labels.select { |s| s.index('2020') }
  next if labels.empty?

  title, url = ha.values_at('title', 'url')

  ret << {
    title: title,
    start_date: Date.parse(labels.first + '.01').to_s.split('-').map(&:to_i),
    end_date: Date.parse(labels.last + '.01').next_month.prev_day.to_s.split('-').map(&:to_i),
    url: url
  }
end
issues = issues.sort_by { |h| Date.parse(h[:start_date].join('.')) }

puts '--> Sample'
puts issues.first(3)

File.write('issues.json', JSON.dump(issues))

puts '--> Write to issues.json'

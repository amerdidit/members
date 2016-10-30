# frozen_string_literal: true
require 'faraday'
require 'pry'
require 'json'

conn = Faraday.new(url: 'https://api.github.com') do |faraday|
  faraday.request  :url_encoded
  faraday.response :logger
  faraday.adapter  Faraday.default_adapter
end

conn.basic_auth 'amerdidit', '971ac079a5b6bc8162204c1854015a27b97f442f'

# Get members
org_name = 'codecentric'
puts "Fetching members for #{org_name}"
response = conn.get do |req|
  req.url "/orgs/#{org_name}/members"
end

members = JSON.parse(response.body)

# binding.pry
puts "#{org_name} has #{members.length} members."

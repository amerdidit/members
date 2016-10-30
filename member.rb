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
org_name = 'logstash'
puts "Fetching members for #{org_name}"
response = conn.get do |req|
  req.url "/orgs/#{org_name}/members"
end

members = JSON.parse(response.body)
puts "#{org_name} has #{members.length} members."

# Get repos for members
puts 'Fetching repos for the members'
members = members.map do |member|
  {
    login: member['login'],
    id: member['id'],
    repos_url: member['repos_url']
  }
end

members = members.each do |member|
  get_repos_response = conn.get do |req|
    req.url member[:repos_url]
  end
  repos = JSON.parse get_repos_response.body

  repos = repos.map do |repo|
    {
      name: repo['name'],
      url: repo['url'],
      language: repo['language']
    }
  end

  member[:repos] = repos
end

puts members

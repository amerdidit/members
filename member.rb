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

members_with_repos = members.each do |member|
  get_repos_response = conn.get do |req|
    req.url member[:repos_url]
  end
  repos = JSON.parse get_repos_response.body

  repos = repos.map do |repo|
    {
      name: repo['name'],
      url: repo['url'],
      languages_url: repo['languages_url']
    }
  end

  member[:repos] = repos
end

# collect languages of the repos
puts 'Collecting the languages of the repos'

members_with_repos_and_langs = members_with_repos.each do |member|
  member[:repos] = member[:repos].each do |repo|
    languages_response = conn.get repo[:languages_url]
    languages = JSON.parse languages_response.body

    repo[:languages] = languages.keys
  end
end

binding.pry

puts members_with_repos_and_langs



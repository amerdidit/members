# frozen_string_literal: true
require 'faraday'
require 'pry'
require 'json'
require 'redis'
require File.expand_path('../environment', __FILE__)

class Fetcher
  def self.fetch
    conn = Faraday.new(url: 'https://api.github.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    conn.basic_auth ENV['GITHUB_USER_NAME'], ENV['GITHUB_TOKEN']

    ###############
    # Get members #
    ###############
    org_name = ENV['ORG_NAME']
    puts "Fetching members for #{org_name}"
    response = conn.get do |req|
      req.url "/orgs/#{org_name}/members"
    end

    members = JSON.parse(response.body)
    puts "#{org_name} has #{members.length} members."

    ##############################
    # Get repos for members      #
    ##############################
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

    ##############################
    # Store members with repos   #
    ##############################

    redis = Redis.new(url: ENV['REDIS_URI'])

    members.each do |member|
      redis.set(member[:login], JSON.generate(member))
    end
  end
end

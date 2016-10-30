# frozen_string_literal: true
require 'faraday'
require 'pry'
require 'json'
require 'redis'
require File.expand_path('../../config/environment', __FILE__)

# = Fetcher
#
# The fetcher class is used to retrieve the members of a specific organisation
# from the github API. It then proceeds to store the members with their repo
# stats in a redis backend.
class Fetcher
  def initialize(redis = Redis.new(url: ENV['REDIS_URI']),
                 org_name = ENV['ORG_NAME'],
                 github_username = ENV['GITHUB_USER_NAME'],
                 github_token = ENV['GITHUB_TOKEN'])
    @connection = configured_connection
    @connection.basic_auth github_username, github_token
    @redis = redis
    @org_name = org_name
  end

  def fetch
    members = get_members
    members = add_repo_stats members
    store_members members
  end

  private

  def store_members(members)
    members.each do |member|
      @redis.set(member[:login], JSON.generate(member))
    end
  end

  def add_repo_stats(members)
    members.each do |member|
      get_repos_response = @connection.get do |req|
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
  end

  def get_members
    response = @connection.get do |req|
      req.url "/orgs/#{@org_name}/members"
    end

    JSON.parse(response.body).map do |member|
      {
        login: member['login'],
        id: member['id'],
        repos_url: member['repos_url']
      }
    end
  end

  def configured_connection
    Faraday.new(url: 'https://api.github.com') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
end

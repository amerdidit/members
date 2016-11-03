# frozen_string_literal: true
require 'redis'
require File.expand_path('../../config/environment', __FILE__)

# = MemberLanguages
#
# MemberLanguages encapsulates the logic of returning the languages of a
# specific member to the user. The data must be retrieved from the Github API
# previous to running this command.
class MemberLanguages
  def initialize
    @redis = Redis.new(url: ENV['REDIS_URI'])
  end

  def list
    list_members
    say "\nPlease input the name of the member you are curious about."
    member_name = ask("\nMember Name: ")
    languages = retrieve_languages member_name
    list_languages languages, member_name
  end

  private

  def list_languages(languages, member_name)
    say "\n - #{member_name}"
    languages.each do |language, count|
      say "    #{language} - #{count}"
    end
  end

  def retrieve_languages(member_name)
    stats = JSON.parse(@redis.get(member_name))
    repos = stats['repos']
    languages = repos.map { |r| r['language'] }
    languages = Hash[languages.group_by { |x| x }.map { |k, v| [k, v.count] }]
    languages.sort_by { |_language, count| count }.reverse
    languages
  end

  def list_members
    say 'The following members exist in your organisation:'
    @redis.keys.each do |key|
      say '- ' + key
    end
  end
end

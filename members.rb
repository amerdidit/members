#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'commander'

require File.expand_path('../fetcher', __FILE__)

class Members
  include Commander::Methods
  # include whatever modules you need

  def run
    program :name, 'members'
    program :version, '0.0.1'
    program :description, 'Retrieves language/repo info about members from a Github organisation.'

    command :fetch do |c|
      c.syntax = 'members fetch'
      c.summary = 'Populates the database with the members of your organisation.'
      c.action do |_args, _options|
        Fetcher.fetch
      end
    end

    command :list_languages do |c|
      c.syntax = 'members list_languages'
      c.description = 'Lists the numbers of repos per language for a given member'
      c.option '--prefix STRING', String, 'Adds a prefix to bar'
      c.option '--suffix STRING', String, 'Adds a suffix to bar'
      c.action do |_args, _options|
        redis = Redis.new(url: ENV['REDIS_URI'])

        say 'The following members exist in your organisation:'
        redis.keys.each do |key|
          say '- ' + key
        end

        say "\nPlease input the name of the member you are curious about."
        member_name = ask("\nMember Name: ")

        stats = JSON.parse(redis.get(member_name))
        languages = sorted_languages stats

        say "\n - #{member_name}"
        languages.each do |language, count|
          say "    #{language} - #{count}"
        end
      end
    end

    run!
  end

  def sorted_languages(stats)
    repos = stats['repos']
    languages = repos.map { |r| r['language'] }
    languages = Hash[languages.group_by { |x| x }.map { |k, v| [k, v.count] }]
    languages.sort_by { |_language, count| count }.reverse
  end
end

Members.new.run if $PROGRAM_NAME == __FILE__

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'commander'

require File.expand_path('../fetcher', __FILE__)
require File.expand_path('../stats', __FILE__)

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
      c.action do |_args, _options|
        Stats.list_languages
      end
    end

    run!
  end
end

Members.new.run if $PROGRAM_NAME == __FILE__

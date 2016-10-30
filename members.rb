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

    run!
  end
end

Members.new.run if $PROGRAM_NAME == __FILE__

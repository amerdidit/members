#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rubygems'
require 'commander'

require File.expand_path('../app/fetcher', __FILE__)
require File.expand_path('../app/stats', __FILE__)

# = Members
#
# This class represents the entry point of the command line application. We
# are using the commander gem in the modular syntax to define the commends.
# For more info pleaase see: https://github.com/commander-rb/commander
class Members
  include Commander::Methods

  def run
    configure_program_metadata
    define_commands
    run!
  end

  private

  def define_commands
    define_fetch
    define_list_languages
  end

  def define_list_languages
    command :list_languages do |c|
      c.syntax = 'members list_languages'
      c.description =
        'Lists the numbers of repos per language for a given member'
      c.action do |_args, _options|
        Stats.list_languages
      end
    end
  end

  def define_fetch
    command :fetch do |c|
      c.syntax = 'members fetch'
      c.summary =
        'Populates the database with the members of your organisation.'
      c.action do |_args, _options|
        Fetcher.new.fetch
      end
    end
  end

  def configure_program_metadata
    program :name, 'members'
    program :version, '0.0.1'
    program :description, 'Retrieves language/repo info about members from a' \
                          'Github organisation.'
  end
end

Members.new.run if $PROGRAM_NAME == __FILE__

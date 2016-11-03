# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'inch/rake'
Inch::Rake::Suggest.new

task default: [:inch, :rubocop, :spec]

# frozen_string_literal: true
require 'spec_helper'
require 'pry'
require 'fakeredis'

require File.expand_path('../../app/fetcher', __FILE__)

RSpec.describe Fetcher do
  before do
    @org_name = Faker::Internet.slug(Faker::Company.name)
    @storage_backend = Redis.new
    allow(@storage_backend).to receive(:set)
    @client = Fetcher.new(@storage_backend, @org_name)
  end

  describe '#fetch' do
    it 'stores members to redis' do
      stub_request(:get, "https://api.github.com/orgs/#{@org_name}/members")
        .to_return(body: MEMBERS_JSON)
      stub_request(:get, "https://api.github.com/users/electrical/repos")
        .to_return(body: ELECTRICAL_REPOS)
      stub_request(:get, "https://api.github.com/users/pyr/repos")
        .to_return(body: PYR_REPOS)

      expect(@storage_backend).to receive(:set)

      @client.fetch
    end
  end
end

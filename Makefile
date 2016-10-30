deps: Gemfile.lock ;

dev: deps
	bundle exec ruby member.rb

Gemfile.lock: Gemfile
	bundle

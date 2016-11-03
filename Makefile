deps: Gemfile.lock ;

dev: deps
	bundle exec guard

Gemfile.lock: Gemfile
	bundle

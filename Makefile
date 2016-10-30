deps: Gemfile.lock ;

dev: deps
	bundle install

Gemfile.lock: Gemfile
	bundle

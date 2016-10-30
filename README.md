# Members

This little Commandline tool will fetch the members of a github organisation 
and store them to a given redis backend. You can then use it to find out 
which languages a specific member has used so far in the repos you have access to. 

# Usage

## Configuration

Configuration lives in the environment. Here's a list of supported variables:

- `GITHUB_USER_NAME` your github user name
- `GITHUB_TOKEN` a github api token created for this app. Get it from here: https://github.com/settings/tokens
- `ORG_NAME` the name of the organisation you want to query
- `REDIS_URI` URI for redi

### Prerequisites

* rbenv 
* bundler
* docker
* docker-compose


```bash
git clone https://github.com/amerdidit/members
cd members
docker-compose up
GITHUB_USER_NAME='<username>' \
    GITHUB_TOKEN='<token>' \
    ORG_NAME='<org>' \
    REDIS_URI='<uri>'
    ./members fetch

REDIS_URI='<uri>' ./members list_languages
```

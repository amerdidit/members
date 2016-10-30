# Members

Lets get some info about those members huh?

# Usage

## Configuration

Configuration lives in the environment. Here's a list of supported variables:

- `GITHUB_USER_NAME` your github user name
- `GITHUB_TOKEN` a github api token created for this app
- `ORG_NAME` the name of the organisation you want to query
- `REDIS_URI` URI for redi

##

```bash
GITHUB_USER_NAME='<username>' \
    GITHUB_TOKEN='<token>' \
    ORG_NAME='<org>' \
    REDIS_URI='<uri>'
    ./members fetch

REDIS_URI='<uri>' ./members list_languages
```

## Development

### Prerequisites

* rbenv 
* bundler
* docker
* docker-compose

```
docker-compose up
make dev
```

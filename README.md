[![Build Status](https://travis-ci.org/apachelogger/rbot-kde-phabricator.svg?branch=master)](https://travis-ci.org/apachelogger/rbot-kde-phabricator)

# Installation

- Clone anywhere
- Install dependencies
  - When using Bundler: `bundle install --without=development`
  - Manually: `gem install finer_struct && gem install faraday`
- Add clone path to `~/.rbot/conf.yaml`
```
plugins.path:
  - /home/me/src/git/rbot-phabricator
```
- Restart bot
- Generate an API token on Phabricator https://phabricator.kde.org/settings/panel/apitokens/
- Set API token in bot config via IRC query
```
[13:03] <sitter> config set phabricator.api_token api-asdfasdfafasdfsdafs
[13:03] <sittingbot> this config change will take effect on the next rescan
```

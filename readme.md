[![Travis](https://travis-ci.org/ga-dc/garnet.svg?branch=master)](https://travis-ci.org/ga-dc/garnet/)

# Garnet

Garnet is a collaboration by the instructors of GA's WDI to produce a student data-tracking app that's better than Google Sheets.

### Please fork, clone, and contribute!

### Current features:

- Extensibility across courses and cohorts
- Mobile-friendly attendance-taking
- Integration with Github
  - Keep track of students' and instructors' Github information
  - Track issues, pull requests, and forks
- A "Report Card" functionality that shows students their current attendance and assignment turn-in rates
- Leave detailed notes on homework submissions in Markdown format
- Leave detailed observations on students in Markdown format
- Admin and nonadmin roles

## Local Setup

1. `$ git clone https://github.com/ga-dc/garnet`
- `$ cd garnet`
- Install headless browser for js features
  - `$ brew install phantomjs`
  - If you get an error about installing on Yosemite (or later), we need phantom 2.x.  Download the latest 2.x from https://github.com/Vitallium/phantomjs/releases and copy `phantomjs` to `/usr/local/bin`.
- `$ bundle install`
- `$ rake db:create`
- `$ rake db:migrate`
- `$ rake db:seed:test_seed`
- `$ bundle exec figaro install`
- [Register a Github application](https://github.com/settings/applications) and update `config/application.yml` to look like this:

    ```
    gh_client_id: "12345"
    gh_client_secret: "67890"
    gh_redirect_url: "http://localhost:3000/github/authenticate"
    check_in_static_ip: "your.static.ip.address"
    ```

9. `$ rspec -f d`
10. `$ rails s`
12. Log in with username `adam` and password `password`
13. Enter the Konami code

`check_in_static_ip` allows site administrators to restrict users "checking in" to a
specific location.

# Models

![The ERD](http://i.imgur.com/jW4WQQK.png)

## Github.rb

The Github model has an API method. To use it:

```rb
# Gets the current organization's repos
request = Github.new(ENV).api.repos

# Gets the current user's repos
request = Github.new(ENV, session[:access_token]).api.repos
```

It's built on the Octokit gem. For more information [see the Octokit docs](https://github.com/octokit/octokit.rb).

Users can sign up *with* or *without* Github.

If they sign up *with* Github, they cannot update their username, password, e-mail, etc. Every time they subsequently sign in, the Github API is polled for their most recent information, and the database is updated accordingly.

If they sign up *without* Github, they can update their username, password, e-mail, etc. Should they wish to later link Github to their account, they can click the "Link Github account" link, which will poll the database, rewrite their information in the Users table to use their Github username, email, etc. From there their account will behave as if they had originally signed up with Github.

# User roles in a specific group

- **Admin**: A user with a physical membership to a group where `membership.is_admin == true`
- **Nonadmin**: A user with a physical membership to a group where `membership.is_admin == false`
- **Admin**: Trickles down: An admin of a group, or an admin of any of its ancestor groups
- **Nonadmin**: Bubbles up: A nonadmin of a group, or a member of any of its descendant groups

# Deployment

When commits are pushed or merged via pull request to master on this repo, [Travis](https://travis-ci.org/ga-dc/garnet)
clones the application, runs `bundle exec rake` to run tests specified in `spec/`.

If all tests pass, travis pushes to the production repo: `git@garnet.wdidc.org:garnet.git`

This triggers a `post-update` hook, which pulls from GitHub's master branch and restarts
unicorn, the application server.

# Troubleshooting

## NewRelic

New Relic monitors the app and provides metrics.  They are available in development mode (/newrelic) and production (rpm.newrelic.com).  It is recommended that you [install newrelic-sysmond on the servers](https://rpm.newrelic.com/accounts/1130222/servers/get_started).

"config/newrelic.yml" was downloaded from rpm.newrelic.com and updated to use `<%= app_name %>`

## RSpec

Use it!

# Debugging

`ssh debug@garnet.wdidc.org` to log in as a read-only user.

Important Places:

- `/var/www/garnet.wdidc.org/logs`
- `/var/www/`

## CLI

### Setup

We have created a garnet function that needs to be "sourced" to be available from the CLI.

1. Use the provided garnet shell file:
  - Either, symlink to your local copy (updated automatically, as you `pull` changes):
  ```
  ln -s absolute_path/to/garnet/garnet ~/.garnet
  ```
  - Or, Download from github:
  ```
  curl https://raw.githubusercontent.com/ga-dc/garnet/cli/garnet > ~/.garnet
  ```
    - Note: to get updates (using this method), just re-download the latest file, replacing the current file.
- Update your ~/.bash_profile to "source" this file (only do this once).
  - e.g. `echo 'source ~/.garnet' >> ~/.bash_profile`


### CLI Usage

Once the file has been sourced, the function is available from terminal.

```
$ garnet logs
```

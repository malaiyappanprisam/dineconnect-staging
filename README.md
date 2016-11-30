README
======

* Download VirtualBox https://www.virtualbox.org/wiki/Downloads
* Install VirtualBox
* Download Vagrant here https://www.vagrantup.com/downloads.html
* Install Vagrant
* Clone `git clone git@github.com:doodine/dineconnect-backend.git`
* cd dineconnect-backend
* `vagrant up` and wait until the download is done
* `vagrant ssh`
* Install dependencies with:

  ```bash
  sudo apt-get update
  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
  ```

* Install ruby with rbenv:

  ```bash
  cd
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  exec $SHELL

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  exec $SHELL

  rbenv install 2.3.1
  rbenv global 2.3.1
  ruby -v
  ```

* Install bundler with:

  ```bash
  gem install bundler
  ```

* Configuring git

  ```bash
  git config --global color.ui true
  git config --global user.name "YOUR NAME"
  git config --global user.email "YOUR@EMAIL.com"
  ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
  ```
* Copy and paste output of following commands to https://github.com/settings/ssh

  ```bash
  cat ~/.ssh/id_rsa.pub
  ```

* Install Rails

  ```bash
  gem install rails -v 4.2.6
  ```

* Rehash rbenv

  ```bash
  rbenv rehash
  ```

* Install postgres

  ```bash
  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install postgresql-common
  sudo apt-get install postgresql-9.5-postgis-2.2 postgresql-contrib-9.5 libpq-dev
  ```

* Edit /etc/environment, add at the end of it with this:

  ```bash
  LANGUAGE=en_US.UTF-8
  LC_ALL=en_US.UTF-8
  LANG=en_US.UTF-8
  LC_TYPE=en_US.UTF-8
  ```

* Logout and ssh to vagrant
  ```bash
  exit

  #outside VM
  vagrant ssh
  ```

* Setup postgres user

  ```bash
  sudo -u postgres createuser ubuntu -s
  ```

* Create database development and test

  ```bash
  psql -dpostgres

  #Inside psql
  CREATE DATABASE dineconnect_dev;
  \c dineconnect_dev
  CREATE EXTENSION postgis;
  CREATE DATABASE dineconnect_test;
  \c dineconnect_test
  CREATE EXTENSION postgis;
  \q
  ```

* Change to vagrant directory

  ```bash
  cd /vagrant
  ```

* Install nodejs

  ```bash
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get install -y nodejs
  ```

* Run bundle install

  ```bash
  bundle install
  ```

* Migrate database with `rake db:migrate`
* Seed database with `rake db:seed`
* Create user by running `rails console`, then `User.create(email: "youremail@example.com", password: "test2017", role: "admin", active: true, email_confirmed_at: DateTime.now, date_of_birth: 20.years.ago)`
* Start rails server
  ```bash
  rails s -b 0.0.0.0
  ```
* On the host machine, open browser to `http://192.168.33.10:3000`
* Login as normal

Creating user in Production
--
* Install heroku toolbelt on your machine, follow this instructions https://toolbelt.heroku.com/
* Create user by running `heroku run rails console`, then `User.create(email: "youremail@example.com", password: "test2017", role: "admin", active: true, email_confirmed_at: DateTime.now, date_of_birth: 20.years.ago))` (on production)

Test
--
To run all the tests, use `rspec spec`

When development of a feature is done
--

* Add all file to git `git add .`
* Commit them `git commit -m "your commit message"`
* Push to github `git push`
* If the push fail because there is an update on github, then do pull rebase `git pull --rebase` then continue with push

Deployment
--

* Login to Heroku
* Go to `https://dashboard.heroku.com/pipelines/110b9f4e-1dfd-4ca6-a7e1-89fdefcdd71b`
* Staging
  * To deploy to staging, click button on the right of staging-dineconnect, choose `deploy a branch`
  * Choose `master` on `Choose Github Branch`
  * Click Deploy
  * Go to command line and go to project directory
  * Run command `heroku run rake db:migrate --app staging-dineconnect`
* Production
  * If already deployed on staging
    * Click `Promote to Production` on staging card
  * If not
    * Click button on the right of dineconnect
    * Choose `master` on `Choose Github Branch`
    * Click Deploy
  * Run command `heroku run rake db:migrate --app dineconnect`

Detail Requirements
--

* Ruby 2.3.1
* Rails 4.2.6
* Postgres 9.5.3 with PostGIS extension
* Using Ruby version 2.3.1

Please run this script on this repository to ensure you always push green spec.

```
cd /path/to/your/repo
curl https://gist.githubusercontent.com/titopandub/c59732cce0e14bad113ed9d5a8242089/raw/pre-push.sh > .git/hooks/pre-push
chmod u+x .git/hooks/pre-push
```

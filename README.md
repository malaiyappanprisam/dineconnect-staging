README
======

* Clone `git clone git@github.com:doodine/dineconnect-backend.git`
* cd dineconecct-backend
* Create database with `rake db:create`
* Migrate database with `rake db:migrate`
* Seed database with `rake db:seed`
* Create user by running `rails console`, then `User.create(email: "youremail@example.com", password: "test2017")`
* Create user by running `heroku run rails console`, then `User.create(email: "youremail@example.com", password: "test2017")` (on production)
* Login as normal
* Use `rspec spec` to run all spec
* Install heroku toolbelt on your machine, follow this instructions https://toolbelt.heroku.com/

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

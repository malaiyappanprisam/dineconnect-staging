README
======

* Using Ruby version 2.3.0
* Clone
* Create database with `rake db:create`
* Migrate database with `rake db:migrate`
* Seed database with `rake db:seed`
* Create user by running `rails console`, then `User.create(email: "youremail@example.com", password: "test2017")`
* Login as normal
* Use `rspec spec` to run all spec

Please run this script on this repository to ensure you always push green spec.

```
cd /path/to/your/repo
curl https://gist.githubusercontent.com/titopandub/c59732cce0e14bad113ed9d5a8242089/raw/pre-push.sh > .git/hooks/pre-push
chmod u+x .git/hooks/pre-push
```

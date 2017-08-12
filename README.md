[CTRL]ALT
==================

Source code powering ctrlalt.io.

#### Dependancies

+ Ruby 2.2.2
+ Postgresql 9.4+
+ Redis
+ ImageMagick
+ Nodejs (V8 Engine)

#### Dependancies

**Ruby**  
To install ruby with rbenv, rvm, chruby or similiar.

**Postgresql**  
Install homebrew and run `brew install postgresql` and follow the instructions to start postgresql. Also make sure `brew doctor` passes.

**Redis**  
Run `brew install redis` and follow the instructions to start redis.

**ImageMagick**  
Run `brew install imagemagick`.

**Nodejs**  
Run `brew install node`.

#### Quickstart

+ Install dependancies.
+ `git clone https://github.com/codyeatworld/ctrlalt-v2.git`
+ `cd ctrlalt-v2`.
+ Update the database configuration `mv config/database.yml.example config/database.yml`.
+ Update the application secrets `mv config/application.yml.example config/application.yml`.
+ `bundle install` to install required gems.
+ `rake db:setup` to setup database tables and load seed data. It creates an administrative user for you. [db/seeds.rb](db/seeds.rb)

**Rails**  
```bash
# run rails with sidekiq using foreman
foreman start -f Procfile.dev
# run rails without sidekiq
rails ss
```

**Sidekiq**  
```bash
# run sidekiq with config
sidekiq -C config/sidekiq.yml
# without config (must specify queues)
sidekiq -q payments,2 -q default
```

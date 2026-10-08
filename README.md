# RottenPotatoes — CHIP 4.8

A Rails 7.1.5 application for creating, viewing, editing, and deleting movies.
Each movie stores a title, rating, description, and release date. The home
page redirects to `/movies`. HTML forms and JSON endpoints are supported.

## Run locally

Use Ruby 3.3.8 and Bundler 2.6.9:

```sh
gem install bundler -v 2.6.9
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open http://localhost:3000/movies. In Codespaces or Docker, run
`bin/rails server -b 0.0.0.0` and forward port 3000.

SQLite is used in development and test; PostgreSQL is used in production.
Seeds can be repeated without duplicating the four initial movies.

## Course repository

The application is on the `MatthewYouth` branch of
[MatthewYouth/hw-hello-rails](https://github.com/MatthewYouth/hw-hello-rails).
A pull request targets `main`. The original assignment instructions are kept
in [instructions/README.md](instructions/README.md).

```sh
git clone https://github.com/MatthewYouth/hw-hello-rails.git
cd hw-hello-rails
git checkout MatthewYouth
```

Do not commit `config/master.key`, local databases, or `.bundle/config`.

## Deploy to Render

1. Create a PostgreSQL database and copy its Internal Connection String.
2. Create a Ruby Web Service connected to the team repository and the branch
   that contains the completed application.
3. Build command: `./bin/render-build.sh`
4. Start command: `ruby -S bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production}`
5. Set `RAILS_ENV=production`, `RACK_ENV=production`,
   `BUNDLE_WITHOUT=development:test`, `DATABASE_URL` to the database connection
   string, and `RAILS_MASTER_KEY` to the contents of `config/master.key`.
   The private project package includes this newly generated key for your
   setup. Keep it private; `.gitignore` excludes it from Git commits.
6. Deploy and verify creating, viewing, editing, and deleting a movie.
7. Create `rottenpotatoes-url.txt` containing only the actual live Render URL
   and submit it to Gradescope. No placeholder submission URL is included.

## AI assistance

ChatGPT assisted with generating the Rails application, implementing the movie
CRUD functionality, configuring deployment, and checking behavior. Review and
adapt this disclosure to your course's submission requirements.

## Verify locally

```sh
RAILS_ENV=test bin/rails db:prepare
RAILS_ENV=test bin/rails runner script/verify.rb
```

The checks cover HTML pages, JSON CRUD, permitted parameters, persisted field
values, deletion, root redirection, and repeatable seeds.

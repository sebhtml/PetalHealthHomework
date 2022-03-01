FROM ruby:3.0.0

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app
COPY . /app

RUN bundle install
RUN bundle exec bin/rake db:migrate
RUN bundle exec bin/rake import_pokemons

CMD ["bin/rails", "server", "-b", "0.0.0.0"]


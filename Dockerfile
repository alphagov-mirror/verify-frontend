FROM ruby:2.4.2

EXPOSE 3000

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN apt-get update && \
    apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile      /app/
COPY Gemfile.lock /app/

RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /app

RUN date '+%s' > /app/.build-number

ENV SECRET_KEY_BASE notused

RUN bash -c 'source .env \
             && export $(cut -d= -f1 .env) \
             && bundle exec rake assets:precompile' \
    && ln -s /app/public/assets /assets

RUN sed -i '/stdout_redirect/d' /app/config/puma.rb

CMD ["rails", "server", "-b", "0.0.0.0"]

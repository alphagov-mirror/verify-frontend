FROM ruby:2.4.2

EXPOSE 3000

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN apt-get update && \
    apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /verify-frontend
WORKDIR /verify-frontend

COPY Gemfile      /verify-frontend/
COPY Gemfile.lock /verify-frontend/

RUN bundle config --global frozen 1
RUN bundle install --without development test

COPY . /verify-frontend

RUN date '+%s' > /verify-frontend/.build-number

ENV SECRET_KEY_BASE notused

RUN bash -c 'source .env \
             && export $(cut -d= -f1 .env) \
             && bundle exec rake assets:precompile' \
    && ln -s /verify-frontend/public/assets /assets

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "8080"]

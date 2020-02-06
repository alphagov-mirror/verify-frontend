FROM ruby:2.6.5

ADD Gemfile Gemfile

RUN bundle install

ADD . /verify-frontend/

WORKDIR /verify-frontend

# Puma needs these dockerignored dirs to write to
RUN mkdir -p log tmp

RUN bundle exec rake assets:precompile \
  && assets:undigest_assets \
  && bundle exec rake assets:copy_govuk_dependencies \
  && bundle exec rake undigest_font_and_image_assets

CMD bundle exec puma -e development -p 80

FROM ruby:2.5.0

ENV APP_ROOT /var/rails
ENV TZ JST-9
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 3000
ENV RAILS_ENV production
ENV RAILS_RELATIVE_URL_ROOT /management
ENV RAILS_SERVE_STATIC_FILES true
ENV DATABASE_URL mysql2://root:mysql123@db/admin?reconnect=true&prepared_statements=true

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

ARG VERSION
ENV VERSION ${VERSION}

ARG FQDN_SUFFIX=${RAILS_RELATIVE_URL_ROOT}

RUN apt-get update -qq && \
    apt-get install -y build-essential apt-transport-https nodejs

RUN gem install bundler

RUN apt-get clean -qq && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
ADD azure.pem azure.pem

RUN bundle install --deployment --without development test

ADD . $APP_ROOT

EXPOSE $PORT

RUN bundle exec rake assets:precompile RAILS_RELATIVE_URL_ROOT=${FQDN_SUFFIX}
CMD bundle exec rails s -p $PORT -b 0.0.0.0 -e $RAILS_ENV

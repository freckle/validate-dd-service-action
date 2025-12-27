FROM ruby:4
MAINTAINER "Freckle Engineering <freckle-engineering@renaissance.com>"
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install
COPY . /app
CMD ["sh", "-c", "cd /app && bundle exec bin/validate"]

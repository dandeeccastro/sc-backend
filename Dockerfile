FROM ruby:3.2.2-alpine3.18

RUN apk add --no-cache ruby-dev zlib-dev yaml-dev tzdata shared-mime-info openssl curl bash make gcc build-base git nodejs libxslt-dev libxml2-dev imagemagick sqlite-dev


WORKDIR /app
ENV HOME=/app \
    RAILS_ENV=production \
    BUNDLE_DEVELOPMENT=1 \
    BUNDLE_WITHOUT=development \
    TZ=America/Sao_Paulo

COPY .ruby-version Gemfile Gemfile.lock ./

RUN bundle install
RUN rails db:migrate db:seed

ENTRYPOINT ["bin/docker-entrypoint"]

COPY . .
EXPOSE 3000
CMD ["bin/rails", "server"]

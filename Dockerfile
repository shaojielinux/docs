FROM harbor.matrixport.dev/base_image/ruby:v1.0

COPY ./Gemfile /usr/src/app/
COPY ./Gemfile.lock /usr/src/app/
WORKDIR /usr/src/app

RUN bundle install

COPY . /usr/src/app

EXPOSE 4567

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]


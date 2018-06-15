FROM ruby:2.3.3 
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 
RUN mkdir /CmdrShepard-webserver 
WORKDIR /CmdrShepard-webserver 
COPY Gemfile /CmdrShepard-webserver/Gemfile 
COPY Gemfile.lock /CmdrShepard-webserver/Gemfile.lock 
RUN bundle install 
COPY . /CmdrShepard-webserver
# CmdrShepard - and this is my favorite shop on the citadel. 
    This project is a chatbot, and a webserver for controlling said chatbot for Twitch, and Discord

## General Setup (Do this first!)

1. Setup the following enviroment variables:
    - DATABASE_HOST - Where our database is going to be on the network (most likely localhost, unless it's a docker app)
    - DATABASE_USER - Our database user for this application
    - DATABASE_PASSWORD - The password to the user
    - TWITCH_KEY - API key for Twitch, so we can use their OAuth
    - TWITCH_SECRET - API secret for Twitch,
    - TWITCH_CHAT_KEY - Second API key for Twitch, so we can use their OAuth to set up our chat user
    - TWITCH_CHAT_SECRET - Second API secret for twtich
    - SPOTIFY_KEY - API key for Spotify so stream requests can happen
    - SPOTIFY_SECRET - API secret for Spotify
    - DISCORD_KEY - API Key for Discord, so we can use their OAuth
    - DISCORD_SECRET - API secret for Discord
    - DISCORD_CHAT_KEY - Key so that our bot can chat
2. Determine whether or not you want to use docker-compose to spin up the program, or run it locally

## Setup for docker-compose
1. In a terminal type 
    ```bash
    docker-compose up
    ```
2. Concider getting a drink, maybe some nice coffee or tea.
3. Jump to "Setting up Twitch Chatbot"
4. Spin down the servers by going into terminal and either ctrl+c the docker-compose command that is currently running or run 
    ```bash
    docker-compose down
    ```
5. Respin up the server with
    ```bash
    docker-compose up
    ```
6. Get that drink because you are done!

## Setup for local setup
1. Install dependancies and set up the database by running in a terminal
    ```bash
        cd ./webserver
        bundle install
        bundle exec rails db:setup
        cd ../chatbot
        bundle install
        cd ..
    ```
2. start up the webserver by running in a terminal
    ```bash
        cd ./webserver
        bundle exec rails s
    ```
3. Jump to "Setting up Twitch Chatbot" once the server is up
4. Start up the chatbot by running in a terminal
    ```bash
        cd ./chatbot
        bundle exec ruby core.rb
    ```
5. Go steal whatever drink the person who used docker-compose grabbed, you're done!

## Setting up Twitch Chatbot
1. Log into the account that you are going to use as your chatbot's account on twitch
2. Once the webserver is up go to `http://web-address-you-set-up(probably_127.0.0.1:3000)/auth/twitch_chat`
3. Authorize the app
4. On your owner account go to `http://web-address-you-set-up(probably_127.0.0.1:3000)/twitch_chat_keys` and enable the account to be used as a twitch chat client
5. Set up which channels the twitch chat client joins
6. GO BACK TO THE REST OF YOUR STEPS
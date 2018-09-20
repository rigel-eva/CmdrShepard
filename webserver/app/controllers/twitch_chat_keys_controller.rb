# frozen_string_literal: true

class TwitchChatKeysController < ApplicationController
  before_action :set_twitch_chat_key, only: [:show, :edit, :update, :destroy]

  # GET /twitch_chat_keys
  # GET /twitch_chat_keys.json
  def index
    @twitch_chat_keys = TwitchChatKey.all
  end

  # GET /twitch_chat_keys/1
  # GET /twitch_chat_keys/1.json
  def show
  end

  # GET /twitch_chat_keys/new
  def new
    @twitch_chat_key = TwitchChatKey.new
  end

  # GET /twitch_chat_keys/1/edit
  def edit
  end

  # POST /twitch_chat_keys
  # POST /twitch_chat_keys.json
  def create
    @twitch_chat_key = TwitchChatKey.new(twitch_chat_key_params)

    respond_to do |format|
      if @twitch_chat_key.save
        format.html { redirect_to @twitch_chat_key, notice: 'Twitch chat key was successfully created.' }
        format.json { render :show, status: :created, location: @twitch_chat_key }
      else
        format.html { render :new }
        format.json { render json: @twitch_chat_key.errors, status: :unprocessable_entity }
      end
    end
  end

  def enable
    key = TwitchChatKey.find(params[:id])
    key.enabled = !key.enabled
    key.save!
    puts key.enabled
    redirect_back(fallback_location: root_path)
  end

  # PATCH/PUT /twitch_chat_keys/1
  # PATCH/PUT /twitch_chat_keys/1.json
  def update
    respond_to do |format|
      puts "twitch_chat_key_params: #{twitch_chat_key_params}"
      if @twitch_chat_key.update(twitch_chat_key_params)
        puts @twitch_chat_key.targetChannels
        format.html { redirect_to @twitch_chat_key, notice: 'Twitch chat key was successfully updated.' }
        format.json { render :show, status: :ok, location: @twitch_chat_key }
      else
        format.html { render :edit }
        format.json { render json: @twitch_chat_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitch_chat_keys/1
  # DELETE /twitch_chat_keys/1.json
  def destroy
    @twitch_chat_key.destroy
    respond_to do |format|
      format.html { redirect_to twitch_chat_keys_url, notice: 'Twitch chat key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_twitch_chat_key
    @twitch_chat_key = TwitchChatKey.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def twitch_chat_key_params
    returner = params["twitch_chat_key"].permit(:enabled).tap do |whitelisted|
      whitelisted[:targetChannels] = params["twitch_chat_key"][:targetChannels][1..-1]
    end
    returner
  end
end

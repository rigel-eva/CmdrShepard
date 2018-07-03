require 'test_helper'

class TwitchChatKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @twitch_chat_key = twitch_chat_keys(:one)
  end

  test "should get index" do
    get twitch_chat_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_twitch_chat_key_url
    assert_response :success
  end

  test "should create twitch_chat_key" do
    assert_difference('TwitchChatKey.count') do
      post twitch_chat_keys_url, params: { twitch_chat_key: {  } }
    end

    assert_redirected_to twitch_chat_key_url(TwitchChatKey.last)
  end

  test "should show twitch_chat_key" do
    get twitch_chat_key_url(@twitch_chat_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_twitch_chat_key_url(@twitch_chat_key)
    assert_response :success
  end

  test "should update twitch_chat_key" do
    patch twitch_chat_key_url(@twitch_chat_key), params: { twitch_chat_key: {  } }
    assert_redirected_to twitch_chat_key_url(@twitch_chat_key)
  end

  test "should destroy twitch_chat_key" do
    assert_difference('TwitchChatKey.count', -1) do
      delete twitch_chat_key_url(@twitch_chat_key)
    end

    assert_redirected_to twitch_chat_keys_url
  end
end

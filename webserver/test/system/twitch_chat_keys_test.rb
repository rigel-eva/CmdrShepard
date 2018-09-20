# frozen_string_literal: true

require "application_system_test_case"

class TwitchChatKeysTest < ApplicationSystemTestCase
  setup do
    @twitch_chat_key = twitch_chat_keys(:one)
  end

  test "visiting the index" do
    visit twitch_chat_keys_url
    assert_selector "h1", text: "Twitch Chat Keys"
  end

  test "creating a Twitch chat key" do
    visit twitch_chat_keys_url
    click_on "New Twitch Chat Key"

    click_on "Create Twitch chat key"

    assert_text "Twitch chat key was successfully created"
    click_on "Back"
  end

  test "updating a Twitch chat key" do
    visit twitch_chat_keys_url
    click_on "Edit", match: :first

    click_on "Update Twitch chat key"

    assert_text "Twitch chat key was successfully updated"
    click_on "Back"
  end

  test "destroying a Twitch chat key" do
    visit twitch_chat_keys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Twitch chat key was successfully destroyed"
  end
end

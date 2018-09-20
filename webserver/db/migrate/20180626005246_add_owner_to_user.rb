# frozen_string_literal: true

class AddOwnerToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :owner, :boolean
  end
end

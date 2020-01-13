class AddAttributesToPlayers < ActiveRecord::Migration[5.2]
  def up
    add_column :players, :firstname, :string
    add_column :players, :lastname, :string
    add_column :players, :position, :string
    add_column :players, :club, :string
    add_column :players, :date_of_birth, :datetime

    add_index :players, :firstname
    add_index :players, :lastname
    add_index :players, :created_at
  end
end

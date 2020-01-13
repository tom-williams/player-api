class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :follower, foreign_key: {to_table: :players}
      t.references :followee, foreign_key: {to_table: :players}

      t.timestamps
    end
  end
end

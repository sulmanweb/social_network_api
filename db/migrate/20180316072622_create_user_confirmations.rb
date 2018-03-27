class CreateUserConfirmations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_confirmations do |t|
      t.references :user, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :token, null: false, default: ''
      t.integer :c_type, null: false

      t.timestamps
    end
    add_index :user_confirmations, :status
    add_index :user_confirmations, :token
    add_index :user_confirmations, :c_type
  end
end

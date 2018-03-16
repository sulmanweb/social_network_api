class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.boolean :status, default: true
      t.string :uid, null: false, default: ''
      t.datetime :last_used_at

      t.timestamps
    end
    add_index :sessions, :status
    add_index :sessions, :uid
  end
end

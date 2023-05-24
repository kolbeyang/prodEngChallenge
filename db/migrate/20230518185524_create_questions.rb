class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question, null: false
      t.string :answer, null:false
      t.integer :ask_count, default: 0

      t.timestamps
    end
  end
end

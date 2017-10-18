class InitialSchema < ActiveRecord::Migration[5.1]
  def change
  	create_table :users do |t|
  		t.string :username
  		t.string :password
  		t.string :picture
  		t.text :bio
  		t.string :firstname
  		t.string :lastname
  	end

  	create_table :posts do |t|
  		t.date :create_at
  		t.text :content
  		t.string :content_url
  		t.integer :rating
  		t.references :user, foreign_key: {to_table: :users}, index: true

  	end
end
end

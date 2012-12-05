class AddPhoneToShop < ActiveRecord::Migration
  def change
    add_column :shops, :phone, :string
  end
end

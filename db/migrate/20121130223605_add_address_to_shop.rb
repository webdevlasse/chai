class AddAddressToShop < ActiveRecord::Migration
  def change
    add_column :shops, :address, :string
    add_column :shops, :city, :string
    add_column :shops, :state_code, :string
    add_column :shops, :postal_code, :string
    add_column :shops, :country_code, :string
  end
end

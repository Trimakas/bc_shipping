class AddCurrencyToStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :currency_symbol, :string
    add_column :stores, :currency_code, :string    
  end
end

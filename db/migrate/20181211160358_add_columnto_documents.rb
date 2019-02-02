class AddColumntoDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :json_response, :string
  end
end

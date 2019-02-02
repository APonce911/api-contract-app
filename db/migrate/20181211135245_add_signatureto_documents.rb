class AddSignaturetoDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :signature_type, :string
  end
end

json.array! @documents do |document|
  json.extract! document, :id, :filename, :status
end

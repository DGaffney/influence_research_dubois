require 'csv'
["cpc", "ndp"].each do |party|
  raw = CSV.open("data/csv/#{party}_nodes_nearly_done.csv")
  raw_dataset = []
  headers = raw.first
  raw.each do |row|
    raw_dataset << Hash[headers.zip(row)]
  end;false
  closeness_of_one_dataset = []
  raw_dataset.each do |row|
    closeness_of_one_dataset << row if row["closnesscentrality"].to_f == 1
  end;false
  closeness_of_one_csv = CSV.open("data/csv/#{party}_closeness_centrality_of_one.csv", "w")
  closeness_of_one_csv << headers
  closeness_of_one_dataset.each do |row|
    closeness_of_one_csv << headers.collect{|k| row[k]}
  end;false
  closeness_of_one_csv.close
end
load 'environment.rb'
load 'gexf.rb'
require 'csv'
["cpc", "ndp"].each do |party|
  nearly_done_file = CSV.open("data/csv/#{party}_nodes_nearly_done.csv", "r")
  nearly_done_header = nearly_done_file.first
  nearly_done_rows = []
  nearly_done_file.each do |row|
    nearly_done_rows << Hash[nearly_done_header.zip(row)]
  end;false
  extracted_file = CSV.open("data/csv/#{party}_nodes_extracted.csv", "r")
  extracted_header = extracted_file.first
  extracted_rows = []
  extracted_file.each do |row|
    extracted_rows << Hash[extracted_header.zip(row)]
  end;false
  modularity_scores = {}
  extracted_rows.each do |row|
    modularity_scores[row["id"]] = row["modularity_class"]
  end;false
  new_dataset = []
  last_id = nil
  nearly_done_rows.each do |row|
    new_row = row
    new_row["modularity_class"] = modularity_scores[row["id"]]
    last_id = row["id"]
    raise "WAT" if modularity_scores[row["id"]].nil?
    new_dataset << new_row
  end;false
  new_csv = CSV.open("data/csv/#{party}_nodes_with_modularity.csv", "w")
  new_header = new_dataset.collect(&:keys).flatten.uniq
  new_csv << new_header
  new_dataset.each do |row|
    new_csv << new_header.collect{|k| row[k]}
  end;false
  puts "Elbow for #{party} is #{modularity_scores.values.counts.values.all_stats[:elbow]}."
end
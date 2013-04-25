require 'csv'
load 'array.rb'
["cpc", "ndp"].each do |party|
  raw = CSV.open("data/csv/#{party}_nodes_nearly_done.csv")
  raw_dataset = []
  raw_headers = raw.first
  raw.each do |row|
    raw_dataset << Hash[raw_headers.zip(row)]
  end;false  
  eigen_above_cutoff = CSV.open("data/csv/#{party}_new_nodes_extracted.csv")
  eigen_above_cutoff_dataset = []
  eigen_above_cutoff_headers = eigen_above_cutoff.first
  eigen_above_cutoff.each do |row|
    eigen_above_cutoff_dataset << Hash[eigen_above_cutoff_headers.zip(row)]
  end;false
  other_vals = {}
  raw_dataset.each do |row|
    ["interaction_count",	"temp_term_score",	"num_tweets",	"term_score_distinct_tweets",	"final_term_score", "clustering"].each do |key|
      other_vals[row["id"]] = {} if other_vals[row["id"]].nil?
      other_vals[row["id"]][key] = row[key]
    end
  end;false
  eigen_above_cutoff_dataset.each do |row|
    row["old_clustering"] = other_vals[row["id"]]["clustering"]
    ["interaction_count",	"temp_term_score",	"num_tweets",	"term_score_distinct_tweets",	"final_term_score"].each do |key|
      row[key] = other_vals[row["id"]][key]
    end
  end;false
  out = CSV.open("data/csv/#{party}_nodes_with_new_clustering.csv", "w")
  headers = eigen_above_cutoff_dataset.collect(&:keys).flatten.uniq
  out << headers
  eigen_above_cutoff_dataset.each do |row|
    out << headers.collect{|k| row[k]}
  end
  out.close
end
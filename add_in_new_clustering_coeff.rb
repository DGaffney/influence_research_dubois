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
  new_clusterings = {}
  eigen_above_cutoff_dataset.each do |row|
    new_clusterings[row["id"]] = row["clustering"]
  end;false
  raw_dataset.each do |row|
    row["new_clustering"] = new_clusterings[row["id"]]
  end;false
  out = CSV.open("data/csv/#{party}_nodes_with_new_clustering.csv", "w")
  headers = raw_dataset.collect(&:keys).flatten.uniq
  out << headers
  raw_dataset.each do |row|
    out << headers.collect{|k| row[k]}
  end
  out.close
end

"interaction_count"	"temp_term_score"	"num_tweets"	"term_score_distinct_tweets"	"final_term_score"

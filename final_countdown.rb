require 'csv'
party = "cpc"
raw_data = CSV.open("data/csv/cpc_nodes_nearly_done.csv", "r")
header = raw_data.first
dataset = []
raw_data.each do |row|
  dataset << Hash[header.zip(row)]
end
interaction_counts = Hash[CSV.read("data/csv/cpc_mention_counts.csv")]
knowledge_counts = Hash[CSV.read("data/csv/cpc_users_term_scores.csv").collect{|r| [r.first,r.last]}]  
ids_eigen_removed = File.read("data/csv/cpc_ids_eigen_removed.csv").split("\n")[1..-1]
`mkdir -p data/csv/cpc`
cpc = CSV.open("data/csv/cpc/cpc.csv", "w")
cpc_eigen_removed = CSV.open("data/csv/cpc/cpc_eigen_removed.csv", "w")
header_for_new_datasets = header
header_for_new_datasets << "interaction_count"
header_for_new_datasets << "knowledge"
cpc << header_for_new_datasets
cpc_eigen_removed << header_for_new_datasets
dataset.each do |partial_row|
  row = partial_row
  row["interaction_count"] = interaction_counts[row["id"]]
  row["knowledge"] = knowledge_counts[row["id"]]
  cpc << header_for_new_datasets.collect{|k| row[k]}
  cpc_eigen_removed << header_for_new_datasets.collect{|k| row[k]} if ids_eigen_removed.include?(row["id"])
end
cpc.close
cpc_eigen_removed.close
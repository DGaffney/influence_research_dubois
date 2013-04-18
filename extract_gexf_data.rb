load 'gephi_extractor.rb'
require 'hashie'
require 'nokogiri'
require 'csv'
["cpc", "ndp"].each do |party|
  print "."
  results = GephiExtractor.run({:gexf_network => File.read("data/graphs/#{party}_updates.gexf")})
  print "."
  node_csv = CSV.open("data/csv/#{party}_nodes_extracted.csv", "w")
  node_keys = [:id, :label, :size]
  node_attributes = ["statuses_count", "followers_count", "friends_count", "listed_count", "favourites_count", "klout_score", "klout_score_bucket", "kred_influence", "kred_outreach", "indegree", "outdegree", "degree", "weighted degree", "weighted indegree", "weighted outdegree", "eccentricity", "closnesscentrality", "betweenesscentrality", "eigencentrality", "newClusteringCoefficient", "clustering", "componentnumber", "strongcompnum", "pageranks", "authority", "hub", "modularity_class"]
  rows = []
  results[:nodes].each do |node|
    row = {}
    node_keys.each do |key|
      row[key] = node[key]
    end
    node_attributes.each do |attribute|
      row[attribute] = node[:attributes].select{|x| x[:for] == attribute}.first[:value] if node[:attributes].select{|x| x[:for] == attribute}.first
    end
    rows << row
  end
  node_csv << (node_keys|node_attributes).collect(&:to_sym)
  rows.each do |row|
    node_csv << (node_keys|node_attributes).collect{|k| row[k]}
  end
  node_csv.close
end
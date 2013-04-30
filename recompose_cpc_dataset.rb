require 'hashie'
require 'nokogiri'
require 'csv'

interaction_counts = Hash[CSV.read("data/csv/#{party}_mention_counts.csv")]
knowledge_counts = Hash[CSV.read("data/csv/#{party}_users_term_scores.csv").collect{|r| [r.first,r.last]}]  
dataset_full = []
dataset_eigen_removed = []
ids_eigen_removed = File.read("data/csv/cpc_ids_eigen_removed.csv").split("\n")[1..-1]

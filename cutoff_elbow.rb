require 'csv'
load 'array.rb'
["cpc", "ndp"].each do |party|
  raw = CSV.open("data/csv/#{party}_nodes_nearly_done.csv")
  raw_dataset = []
  headers = raw.first
  raw.each do |row|
    raw_dataset << Hash[headers.zip(row)]
  end;false  
  elbow = raw_dataset.collect{|row| row["eigencentrality"].to_f}.elbow_cutoff
  eigen_above_cutoff_dataset = []
  raw_dataset.each do |row|
    eigen_above_cutoff_dataset << row if row["eigencentrality"].to_f <= elbow
  end;false
  eigen_above_cutoff_csv = CSV.open("data/csv/#{party}_eigen_above_cutoff.csv", "w")
  eigen_above_cutoff_csv << headers
  eigen_above_cutoff_dataset.each do |row|
    eigen_above_cutoff_csv << headers.collect{|k| row[k]}
  end;false
  eigen_above_cutoff_csv.close
  puts "Elbow is #{elbow}; #{raw_dataset.count-eigen_above_cutoff_dataset.count} nodes removed."
end
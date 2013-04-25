require 'csv'
load 'array.rb'
["cpc", "ndp"].each do |party|
  dataset = {}
  raw = File.read("data/awful_data_outputs/#{party}_eigen_above_cutoff.txt").split("\n")
  analysis = nil
  modularity_class = nil
  headers = nil
  uniq_analytics = nil
  line_count = nil
  raw.each do |line|
    if line.include?("indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count")
      analysis = line.split(" ")[1]
      dataset[analysis] = {} if dataset[analysis].nil?
      headers = line.split(" ")[2..-1].all_combinations(2..2)
      line_count = 0
      uniq_analytics = headers.flatten.uniq
    elsif line.include?(" | ") && line.split(" ").last.to_f != 0
      values = line.split(" ")[2..-2]
      values.each do |value|
        header = headers[line_count].join("/")
        dataset[analysis][header] = value
        line_count+=1
      end
    end
  end
  refined_dataset = []
  matchups = headers.collect{|h| h.join("/")}
  matchups.each do |matchup|
    refined_dataset = [] if refined_dataset.nil?
    refined_dataset << {:matchup => matchup, :spearman => dataset["spearman"][matchup], :ktau => dataset["ktau"][matchup]}
  end
  finished = CSV.open("data/csv/eigen_above_cutoff_rankings_#{party}.csv", "w")
  finished << ["matchup", "ktau", "spearman"]
  refined_dataset.each do |row|
    finished << [row[:matchup], row[:spearman], row[:ktau]]
  end
  finished.close
end
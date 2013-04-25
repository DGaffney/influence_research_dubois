require 'csv'
load 'analytic.rb'
["cpc", "ndp"].each do |party|
  dataset = {}
  raw = File.read("data/awful_data_outputs/output_#{party}.txt").split("\n")
  analysis = nil
  modularity_class = nil
  headers = nil
  uniq_analytics = nil
  line_count = nil
  raw.each do |line|
    if line.include?("if modularity_class == ")
      analysis = line.split(" ")[1]
      modularity_class = line.split(" ").last
      dataset[modularity_class] = {} if dataset[modularity_class].nil?
      dataset[modularity_class][analysis] = {} if dataset[modularity_class][analysis].nil?
      headers = line.split(" ")[2..-5].all_combinations(2..2)
      line_count = 0
      uniq_analytics = headers.flatten.uniq
    elsif line.include?(" | ") && line.split(" ").last.to_f != 0
      values = line.split(" ")[2..-2]
      values.each do |value|
        header = headers[line_count].join("/")
        dataset[modularity_class][analysis][header] = value
        line_count+=1
      end
    end
  end
  refined_dataset = {}
  modularity_classes = dataset.keys
  matchups = headers.collect{|h| h.join("/")}
  matchups.each do |matchup|
    modularity_classes.each do |modularity_class|
      refined_dataset[modularity_class] = [] if refined_dataset[modularity_class].nil?
      refined_dataset[modularity_class] << {:matchup => matchup, :spearman => dataset[modularity_class]["spearman"][matchup], :ktau => dataset[modularity_class]["ktau"][matchup]}
    end
  end
  `mkdir -p data/csv/modularity_scores`
  refined_dataset.each_pair do |modularity_class, rows|
    finished = CSV.open("data/csv/modularity_scores/modularity_class_rankings_#{party}_#{modularity_class}.csv", "w")
    finished << ["matchup", "ktau", "spearman"]
    rows.each do |row|
      spearman = row
      finished << [row[:matchup], row[:spearman], row[:ktau]]
    end
    finished.close
  end
end
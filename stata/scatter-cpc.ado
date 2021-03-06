clear
run "/Users/dgaffney/Desktop/Life/Work/Academics/Oxford/Hilary/Quant/Week 2/lowessmat.ado"
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/cpc_nodes_nearly_done.csv
clear
run "/Users/dgaffney/Desktop/Life/Work/Academics/Oxford/Hilary/Quant/Week 2/lowessmat.ado"
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/cpc_new_nodes_extracted.csv
*statuses_count followers_count friends_count listed_count favourites_count klout_score kred_influence kred_outreach 
*indegree eccentricity closnesscentrality betweenesscentrality eigencentrality newClusteringCoefficient clustering 
*pageranks authority hub modularity_class 

scatter indegree klout_score, symbol(oh) msize(*2) title(Indegree by Klout Score)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-klout.png", as(png)
scatter indegree kred_influence, symbol(oh) msize(*2) title(Indegree by Kred Influence)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-kred-influence.png", as(png)
scatter indegree kred_outreach, symbol(oh) msize(*2) title(Indegree by Kred Outreach)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-kred-outreach.png", as(png)
scatter indegree pageranks, symbol(oh) msize(*2) title(Indegree by PageRank)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-pagerank.png", as(png)
scatter indegree authority, symbol(oh) msize(*2) title(Indegree by Authority)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-authority.png", as(png)
scatter indegree statuses_count, symbol(oh) msize(*2) title(Indegree by Statuses Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-statuses-count.png", as(png)
scatter indegree followers_count, symbol(oh) msize(*2) title(Indegree by Followers Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-followers-count.png", as(png)
scatter indegree eigencentrality, symbol(oh) msize(*2) title(Indegree by Eigen Centrality)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-indegree-eigencentrality.png", as(png)

scatter followers_count klout_score, symbol(oh) msize(*2) title(Followers Count by Klout Score)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-klout.png", as(png)
scatter followers_count kred_influence, symbol(oh) msize(*2) title(Followers Count by Kred Influence)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-kred-influence.png", as(png)
scatter followers_count kred_outreach, symbol(oh) msize(*2) title(Followers Count by Kred Outreach)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-kred-outreach.png", as(png)
scatter followers_count pageranks, symbol(oh) msize(*2) title(Followers Count by PageRank)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-pagerank.png", as(png)
scatter followers_count authority, symbol(oh) msize(*2) title(Followers Count by Authority)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-authority.png", as(png)
scatter followers_count statuses_count, symbol(oh) msize(*2) title(Followers Count by Statuses Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-statuses-count.png", as(png)
scatter followers_count eigencentrality, symbol(oh) msize(*2) title(Followers Count by Eigen Centrality)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc/scatter-followers-count-eigencentrality.png", as(png)

gen log_indegree             = log(indegree+0.5)         
gen log_pageranks            = log(pageranks+0.5)
gen log_authority            = log(authority+0.5)
gen log_betweenesscentrality = log(betweenesscentrality+0.5)
gen log_statuses_count       = log(statuses_count+0.5)
gen log_followers_count      = log(followers_count+0.5)
gen log_eigencentrality      = log(eigencentrality+0.5) 

lowessmat indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc_splom.pdf", as(pdf) replace
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/cpc_splom.png", as(png) replace

*corr log_indegree klout_score kred_influence log_authority closnesscentrality log_betweenesscentrality log_statuses_count log_followers_count log_eigencentrality clustering
*spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering, stats(p rho)
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count
alpha indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering, item
alpha indegree authority
*Tips from Zander:
* run a spearman or k-tau (figure out the difference) to test ranks - ranking is going to be more valid than just straight correlation
* then, you may want to run a cronbach's alpha to see if the metrics are measuring the same underlying construct. A high value indicates that a pair of matches are measuring the same thing.
* then, run a residuals test against all the people in the dataset to see who the outliers are.
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 47, matrix
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 390
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 140
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 372
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 55
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 320
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 315
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 47
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 390
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 140
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 372
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 55
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 320
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering final_term_score interaction_count if modularity_class == 315


clear
run "/Users/dgaffney/Desktop/Life/Work/Academics/Oxford/Hilary/Quant/Week 2/lowessmat.ado"
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/cpc_nodes_with_new_clustering.csv
ktau indegree followers_count eigencentrality clustering knowledge_count interaction_count
spearman indegree followers_count eigencentrality clustering knowledge_count interaction_count
ktau indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering knowledge_count interaction_count
spearman indegree klout_score kred_influence authority closnesscentrality betweenesscentrality statuses_count followers_count eigencentrality clustering knowledge_count interaction_count
[90227660,146087611,87769317]


clear
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/cpc/cpc.csv
ktau indegree followers_count eigencentrality clustering knowledge interaction_count
spearman indegree followers_count eigencentrality clustering knowledge interaction_count
clear
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/cpc/cpc_eigen_removed.csv
ktau indegree followers_count eigencentrality clustering knowledge interaction_count
spearman indegree followers_count eigencentrality clustering knowledge interaction_count

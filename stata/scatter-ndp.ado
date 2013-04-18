clear
run "/Users/dgaffney/Desktop/Life/Work/Academics/Oxford/Hilary/Quant/Week 2/lowessmat.ado"
insheet using ~/Desktop/Life/Work/Publications/influence_research_dubois/data/csv/ndp_nodes_extracted.csv
*statuses_count followers_count friends_count listed_count favourites_count klout_score kred_influence kred_outreach 
*indegree eccentricity closnesscentrality betweenesscentrality eigencentrality newClusteringCoefficient clustering 
*pageranks authority hub modularity_class 

scatter indegree klout_score, symbol(oh) msize(*2) title(Indegree by Klout Score)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-klout.png", as(png)
scatter indegree kred_influence, symbol(oh) msize(*2) title(Indegree by Kred Influence)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-kred-influence.png", as(png)
scatter indegree kred_outreach, symbol(oh) msize(*2) title(Indegree by Kred Outreach)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-kred-outreach.png", as(png)
scatter indegree pageranks, symbol(oh) msize(*2) title(Indegree by PageRank)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-pagerank.png", as(png)
scatter indegree authority, symbol(oh) msize(*2) title(Indegree by Authority)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-authority.png", as(png)
scatter indegree statuses_count, symbol(oh) msize(*2) title(Indegree by Statuses Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-statuses-count.png", as(png)
scatter indegree followers_count, symbol(oh) msize(*2) title(Indegree by Followers Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-followers-count.png", as(png)
scatter indegree eigencentrality, symbol(oh) msize(*2) title(Indegree by Eigen Centrality)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-indegree-eigencentrality.png", as(png)

scatter followers_count klout_score, symbol(oh) msize(*2) title(Followers Count by Klout Score)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-klout.png", as(png)
scatter followers_count kred_influence, symbol(oh) msize(*2) title(Followers Count by Kred Influence)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-kred-influence.png", as(png)
scatter followers_count kred_outreach, symbol(oh) msize(*2) title(Followers Count by Kred Outreach)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-kred-outreach.png", as(png)
scatter followers_count pageranks, symbol(oh) msize(*2) title(Followers Count by PageRank)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-pagerank.png", as(png)
scatter followers_count authority, symbol(oh) msize(*2) title(Followers Count by Authority)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-authority.png", as(png)
scatter followers_count statuses_count, symbol(oh) msize(*2) title(Followers Count by Statuses Count)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-statuses-count.png", as(png)
scatter followers_count eigencentrality, symbol(oh) msize(*2) title(Followers Count by Eigen Centrality)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp/scatter-followers-count-eigencentrality.png", as(png)

gen log_indegree             = log(indegree+0.5)         
gen log_pageranks            = log(pageranks+0.5)
gen log_authority            = log(authority+0.5)
gen log_betweenesscentrality = log(betweenesscentrality+0.5)
gen log_statuses_count       = log(statuses_count+0.5)
gen log_followers_count      = log(followers_count+0.5)
gen log_eigencentrality      = log(eigencentrality+0.5) 

lowessmat log_indegree klout_score kred_influence log_authority closnesscentrality log_betweenesscentrality log_statuses_count log_followers_count log_eigencentrality clustering
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp_splom.pdf", as(pdf)
graph export "~/Desktop/Life/Work/Publications/influence_research_dubois/data/scatter_plots/ndp_splom.png", as(png)

corr log_indegree klout_score kred_influence log_authority closnesscentrality log_betweenesscentrality log_statuses_count log_followers_count log_eigencentrality clustering
library(rmarkdown)

for(cluster in 1:15) {
  
  render("interactive_report.Rmd",
         output_file = paste0("cluster", cluster, ".html"),
         params = list(cluster = cluster))
  
  
  
}
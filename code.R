
graph [overlap = true, fontsize = 5]
ndf <- create_node_df(n = 2, label = c("2384jk lafsdj sfdk ", 3942),
                      shape = c("circle"))
# Create an edge data frame (edf)
edf <- create_edge_df(from = c(1, 2),
                      to = c(2, 1),
                      rel = c("a", "b"),
                      label = c("aa", "bb"))
# Create a graph with the ndf and edf
graph <- create_graph(nodes_df = ndf,
                      edges_df = edf,
                      attr_theme = )
render_graph(graph)

library(RSQLite)
database <- "db.sqlite"
con <- dbConnect(RSQLite::SQLite(), database)
resultset = dbGetQuery(con, "select distinct pricePerUnit from material where description like 'FER-01'")
resultset$pricePerUnit[1]

alltables = dbListTables(con)
dbDisconnect(con)


con <- dbConnect(RSQLite::SQLite(), database)
resultset = alltables = dbListTables(con)
dbDisconnect(con)
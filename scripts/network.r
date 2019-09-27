source("scripts/utils.r")

library(igraph)
library(ggraph)

# available layouts in igraph:
# layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1]

## clean environment
# rm(list = ls())

fp.graph <- '../data/graph/'

fp.tags_nodes <- paste(fp.graph, 'mpis--tags_nodes.csv', sep="")
fp.cats_nodes <- paste(fp.graph, 'mpis--cats_nodes.csv', sep="")
fp.cats_tags_edges <- paste(fp.graph, 'mpis--cats-tags_edges.csv', sep="")

fp.ous_nodes <- paste(fp.graph, 'pure--ous_nodes.csv', sep="")
fp.ous_edges <- paste(fp.graph, 'pure--ous_ous_edges.csv', sep="")

fp.mpis_nodes <- paste(fp.graph, 'mpis--ous_nodes.csv', sep="")
fp.mpis_nodes.tree <- paste(fp.graph, 'mpis--ous_nodes--tree-full.csv', sep="")
fp.mpis_edges <- paste(fp.graph, 'mpis--ous_ous_edges--tree.csv', sep="")

fp.mpis_cats_edges <- paste(fp.graph, 'mpis--ous_cat_edges.csv', sep="")
fp.mpis_tags_edges <- paste(fp.graph, 'mpis--ous_tags_edges.csv', sep="")

############################
### Organizational Units ###
############################

nodes.ous <- read.data(fp.ous_nodes)
edges.ous <- read.data(fp.ous_edges)
edges.ous <- edges.ous[,c(2,1)] # flip columns

net.ous <- graph_from_data_frame( edges.ous )

ggraph(net.ous, layout = 'circlepack') + 
  geom_node_circle() +
  theme_void()

#############################
### Max Planck Institutes ###
#############################

nodes.mpis.tree <- read.data(fp.mpis_nodes.tree)

# add parent to list of nodes (extraction was down from institutes downwards...)
nodes.mpis.tree <- rbind(nodes.mpis.tree,
                    data.frame(Id=c('ou_persistent13'),
                               Label=c('Max Planck Gesellschaft')))

edges.mpis <- read.data(fp.mpis_edges)
edges.mpis <- edges.mpis[,c(2,1)] # flip columns

net.mpis <- graph_from_data_frame( edges.mpis, vertices=nodes.mpis.tree )

ggraph(net.mpis, layout = 'circlepack') + 
  geom_node_circle(aes(fill=depth)) +
  # geom_node_text( aes(label=Label)) +
  theme_void() + 
  theme(legend.position="FALSE") + 
  scale_fill_viridis()

###################################
### Topical Categories and Tags ###
###################################

nodes.cats <- read.data(fp.cats_nodes)
nodes.tags <- read.data(fp.tags_nodes)
edges.cats.tags <- read.data(fp.cats_tags_edges)

nodes.cats$Type = rep(T,length(nodes.cats[,1]))
nodes.tags$Type = rep(F,length(nodes.tags[,1]))
# m <- as.matrix(get.adjacency(graph.data.frame(edges.cats.tags)))

nodes <- rbind(nodes.cats,nodes.tags)
nodes$IsCategory <- with(nodes, grepl("category_\\d", Id))

net.cats.tags <- graph_from_data_frame(d=edges.cats.tags, vertices=nodes, directed=F)

V(net.cats.tags)$type <- nodes$Type

plot(net.cats.tags,
     edge.color="orange",
     vertex.color=ifelse(V(net.cats.tags)$Type, "green", "tomato"),
     # vertex.label = V(net.cats.tags)$Label,
     vertex.label = ifelse(V(net.cats.tags)$Type, V(net.cats.tags)$Label, NA),
     vertex.label.family="Helvetica",
     vertex.label.cex=0.75,
     # vertex.label.cex=ifelse(V(net.cats.tags)$Type, 1, 0.75),
     vertex.size= 7.5,
     # vertex.size=ifelse(V(net.cats.tags)$Type, 10, 7.5),
     vertex.label.color="black",
     vertex.frame.color="white")

# weight by degree

deg <- degree(net.cats.tags, mode="all")
V(net.cats.tags)$size <- deg # *3

plot(net.cats.tags,
     edge.color="orange",
     vertex.color=ifelse(V(net.cats.tags)$IsCategory, "green", "tomato"),
     vertex.label = ifelse(V(net.cats.tags)$IsCategory, V(net.cats.tags)$Label, NA),
     # vertex.label = V(net.cats.tags)$Label,
     vertex.label.family="Helvetica",
     # vertex.label.cex=0.75,
     vertex.label.cex=ifelse(V(net.cats.tags)$Type, 1, 0.75),
     vertex.size=ifelse(V(net.cats.tags)$IsCategory, deg, 7.5),
     vertex.label.color="black",
     vertex.frame.color="white")

# make_bipartite_graph(vertices$Type, edges.cats.tags, directed = FALSE)

bipartite.projection(net.cats.tags)

##################################################
### Institutes and Topical Categories and Tags ###
##################################################

nodes.mpis <- read.data(fp.mpis_nodes)
nodes.cats <- read.data(fp.cats_nodes)
nodes.tags <- read.data(fp.tags_nodes)

edges.mpis_cats <- read.data(fp.mpis_cats_edges)
edges.mpis_tags <- read.data(fp.mpis_tags_edges)

nodes <- rbind(nodes.mpis, nodes.cats)
nodes$IsCategory <- with(nodes, grepl("category_\\d", Id))
net.mpis.cats <- graph_from_data_frame(d=edges.mpis_cats, vertices=nodes, directed=F)

# edges.mpis_cats[,2] %in% nodes.mpis[,1]

deg <- degree(net.mpis.cats, mode="all")
V(net.mpis.cats)$size <- deg # *3

plot(net.mpis.cats,
     edge.color="orange",
     vertex.size=9,
     # vertex.size=ifelse(V(net.mpis.cats)$IsCategory, deg, 10),
     vertex.color=ifelse(V(net.mpis.cats)$IsCategory, "green", "SkyBlue2"),
     vertex.label = ifelse(V(net.mpis.cats)$IsCategory, V(net.mpis.cats)$Label, NA),
     # vertex.label= V(net)$Label
     vertex.label.cex=1,
     vertex.label.color="black",
     vertex.label.family="Helvetica",
     vertex.frame.color="white")


clp <- cluster_label_prop(net.mpis.cats)

# plot(clp, net.mpis.cats)

plot(clp, net.mpis.cats,
     edge.color="green",
     # vertex.size=10,
     # vertex.color=ifelse(V(net.mpis.cats)$IsCategory, "green", "blue"),
     vertex.label = ifelse(V(net.mpis.cats)$IsCategory, V(net.mpis.cats)$Label, NA),
     # vertex.label.font=2,
     vertex.size=ifelse(V(net.mpis.cats)$IsCategory, deg, 10),
     vertex.label.family="Helvetica",
     vertex.label.cex=0.75,
     # vertex.label="",# V(net)$Label
     vertex.label.color="black",
     vertex.frame.color="white")

V(net.mpis.cats)$community <- clp$membership
colrs <- adjustcolor( c("SkyBlue2", "tomato","gold"), alpha=.9)
# plot(net, vertex.color=colrs[V(net)$community])

plot(net.mpis.cats,
     edge.color="green",
     vertex.color=ifelse(V(net.mpis.cats)$IsCategory, "green", colrs[V(net.mpis.cats)$community]),
     vertex.label = ifelse(V(net.mpis.cats)$IsCategory, V(net.mpis.cats)$Label, NA),
     # vertex.label.font=2,
     # vertex.size=10,
     vertex.size=ifelse(V(net.mpis.cats)$IsCategory, deg, 10),
     vertex.label.family="Helvetica",
     vertex.label.cex=0.75,
     # vertex.label="",# V(net)$Label
     vertex.label.color="black",
     vertex.frame.color="white")



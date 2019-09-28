
source("scripts/utils.r")

library(igraph)

nodes <- c('Tag','Category','Organizational Unit','Context','Item','Creator')

source <- c('Organizational Unit','Context','Item','Tag', 'Category','Item','Creator','Tag','Category','Creator')
target <- c('Organizational Unit','Organizational Unit','Context','Organizational Unit','Organizational Unit','Creator','Creator','Tag','Category','Organizational Unit')


edges.entities <- data.frame(source=source, target=target)

net.entities <- graph_from_data_frame( edges.entities, vertices=nodes )


plot(net.entities,
     edge.color="SkyBlue2",
     vertex.color="tomato",
     vertex.label = V(net.entities)$Label,
     vertex.label.family="Helvetica",
     vertex.label.cex=0.75,
     vertex.size= 10,
     vertex.label.color="black",
     vertex.frame.color="white")

# entities <- data.frame()
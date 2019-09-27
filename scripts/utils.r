read.data <- function(x) {
    data <- read.csv(x,
                     sep = ",",
                     encoding = "UTF-8",
                     header = T,
                     quote = '"',
                     stringsAsFactors = F)
    return(data)
}

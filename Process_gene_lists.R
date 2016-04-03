library(dplyr)
library(tidyr)
library(stringr)

inner_join_by_field <- function(x, y, field = "locus") {
  inner_join(x, y, by = field)
}

tag = '18'
filename_pattern = paste0(tag, '_[[:alnum:]]{4}tive')
test <- list.files(pattern = filename_pattern) %>% 
  lapply(read.delim) %>% 
  lapply(filter, locus != 'none') %>% 
  lapply(separate, col = ID, into = c('transcript', 'isoform'), sep = '_i') %>% 
  lapply(select, -isoform, -log_foldchange) %>% 
  lapply(distinct)

## to do: join positive/negative tables across lines
## get rid of repeating lapply's
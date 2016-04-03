library(plyr)
library(dplyr)
library(stringr)

# function for extracting count columns from multiple tables
# column name is hardcoded
# only works with plyr-style rename!

extract_counts_from_file <- function(x) {
  select(read.delim(x), gene_id, expected_count) %>% 
    plyr::rename(setNames(str_extract(x, '[189]{2}[OK]{1}'), 'expected_count'))
}

# accessory function for joining two tables by provided field
# default field - 'gene_id'

inner_join_by_field <- function(x, y, field = "gene_id") {
  inner_join(x, y, by = field)
}

# reads all files from directory specified by tag
# extracts columns with counts and renames them
# joins all tables by gene_id column
# writes data into text file with name specified by tag

from_RSEM_to_matrix <- function(tag) {
  list.files(path = paste0('./RSEM_vs_', tag, '/'), full.names = T) %>%
  lapply(extract_counts_from_file) %>%
  Reduce(inner_join_by_field, .) %>%
  write.table(file = paste0('expr_matrix_', tag, '.txt'), quote = F)
}

from_RSEM_to_matrix('18')
from_RSEM_to_matrix('19')


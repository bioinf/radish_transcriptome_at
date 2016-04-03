setwd("~/Dropbox/Linux_sharing/")
setwd("~/Dropbox//Separate_assemblies_radish/")

library(DESeq2)
library(dplyr)

conditions_file <- "Conditions.txt"  # path to conditions table
condTable <- read.table(conditions_file, header = T)

expfile <- 'expr_matrix_18.txt'  # path to count matrix

exptable <- read.table(expfile, header = T, row.names = 1)
row.names(exptable) <- exptable$gene_id
exptable$gene_id <- NULL  # delete gene_id column


# conditions to test

cond1 = 'K'
cond2 = 'O'

exp12r <- round(exptable, 0)  # convert count data to integers

# Run DEseq2 functions

results <- DESeqDataSetFromMatrix(countData = as.matrix(exp12r),
                                  colData = condTable,
                                  design = ~Condition) %>%
  DESeq(.) %>% 
  results(.)

resOrdered <- results[order(results$pvalue),]  # order results by p-value

# Proceed with whatever downstream analysis, filtering, 
# subsetting is necessary

dim(subset(resOrdered, resOrdered$padj < 0.1))

tag <- paste(cond1, "vs", cond2, sep="_") # tag to write the output file

output <- paste0(tag, ".18ref.DESeq.out")

# Write results to a separate file ready for annotation

write.table(subset(resOrdered, resOrdered$padj < 0.1),
            file=output,
            quote=F,
            sep = '\t')

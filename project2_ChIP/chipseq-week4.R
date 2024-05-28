library(tibble)
library(tidyverse)
library(dplyr)
library(ggplot2)

# creating a tibble out of the deseq results 
df <- read.table("GSE75070_MCF7_shRUNX1_shNS_RNAseq_log2_foldchange.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
deseq_tib <- as_tibble(df)

# creating a tibble out of the annotations
df2 <- read.table("results/peaks_repr_filtered_annotations.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
annotations_tib <- as_tibble(df2)

#filter the deseq results p < 0.01, log2FC > abs 1

filtered_deseq <- deseq_tib %>% 
  filter(abs(log2FoldChange) > 1 & padj < 0.01) %>%
  mutate(Status = case_when(log2FoldChange > 0 ~ "UP", log2FoldChange < 0 ~ "DOWN"))

count_summary <- filtered_deseq %>%
  count(Status)


#left join with deseq on the left so the NA's on the deseq side are UNBOUND
annotations_tib = rename(annotations_tib, genename = Gene.Name)

joined_tib <- left_join(x= filtered_deseq, y= annotations_tib, by = "genename")

#Using the list of DE genes downloaded in step 1 and the annotated peak
#file you generated previously, recreate figure 2f and supplementary figure
#S2D and produce stacked barcharts showing the proportions of DE genes with a
#Runx1 peak found within +/- 5kb, +/- 20kb, and +/- 100kb of the TSS

# take the absolute value of the tSS column and see which ones are less than 5000


kb5_df <- joined_tib %>%
  mutate(bound_unbound = if_else(is.na(Distance.to.TSS) | abs(Distance.to.TSS) > 5000, "unbound", "bound")) 
  
kb5_df_test <- mutate(kb5_df, Status_5 = case_when(
  log2FoldChange > 0 ~ "UP_5",
  log2FoldChange < 0 ~ "DOWN_5"))


kb20_df <- joined_tib %>%
  mutate(bound_unbound = if_else(is.na(Distance.to.TSS) | abs(Distance.to.TSS) > 20000, "unbound", "bound"))

kb20_df_test <- mutate(kb20_df, Status_20 = case_when(
  log2FoldChange > 0 ~ "UP_20",
  log2FoldChange < 0 ~ "DOWN_20"))

kb100_df <- joined_tib %>%
  mutate(bound_unbound = if_else(is.na(Distance.to.TSS) | abs(Distance.to.TSS) > 100000, "unbound", "bound"))

kb100_df_test <- mutate(kb100_df, Status_100 = case_when(
  log2FoldChange > 0 ~ "UP_100",
  log2FoldChange < 0 ~ "DOWN_100"))



# make the plot
# where x axis is differential expression up or down, 
# position = fill will stack based on bound and unbound
# this will give percents of gene
# individual geom bar



#fill= bound, position = fill
my_colors <- c("bound" = "red", "unbound" = "grey")

# Create the plot
my_barplot <- ggplot() +
  geom_bar(data = kb5_df_test, aes(x = Status_5, fill = bound_unbound), position = "fill", width = 0.5) +
  geom_bar(data = kb20_df_test, aes(x = Status_20, fill = bound_unbound), position = "fill", width = 0.5) +
  geom_bar(data = kb100_df_test, aes(x = Status_100, fill = bound_unbound), position = "fill", width = 0.5) +
  scale_fill_manual(values = my_colors) +
  scale_x_discrete(limits = c('UP_5', 'DOWN_5', 'UP_20', 'DOWN_20', 'UP_100', 'DOWN_100')) +
  scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +  # Set y-axis to percentage
  theme_minimal() + 
  labs(x = "  +/- 5kb of TSS     +/- 20kb of TSS     +/- 100kb of TSS     ", y = "Percentage of genes")

# View the plot
print(my_barplot)


jpeg("my_plot.jpg", width = 800, height = 600)
print(my_barplot)
dev.off()
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(gridExtra)
library(forcats)

# Set location of expression matrix file
fname <- '~/Desktop/differentiating_islets.log2_TPM.tsv'

####### Do not edit passed here ######

df = read_tsv(
  fname, 
  col_names = TRUE
)

# Gene symbol
gene <- 'ARRDC4'
gene_col <- rlang::sym(gene)

theme_set(
  theme_classic() +
    theme(legend.position = "top")
)


p1 <- ggplot(df %>% filter(include_in_time_series == TRUE)) + 
  geom_point(
      aes(
        x = day, 
        y  = !!gene_col
      ), 
      size=3, 
      colour="#884dff", 
      alpha=0.35
  ) + 
  stat_summary(
    fun=mean, 
    geom="line", 
    aes(
      x=day, 
      y=!!gene_col
    ), 
    color='#20c75d'
  ) + 
  stat_summary(
    fun.data=mean_sdl, 
    #geom="crossbar",
    fun.args = list(mult = 1),
    aes(
      x=day, 
      y=!!gene_col
    ), 
    color='#20c75d'
  ) + ylim(0, max(df[gene_col])+0.5)

p2 <- ggplot(
    df %>% filter(
      include_in_time_series == FALSE) %>% 
      mutate(sample_type = fct_relevel(
        sample_type, 
        "not_enriched_beta", 
        "mature_islet")
      )
  ) +
  geom_point(
    aes(
      x = sample_type, 
      y  = !!gene_col
    ), 
    size=3, 
    colour="#884dff", 
    alpha=0.35
  ) + 
  stat_summary(
    fun.data=mean_sdl, 
    #geom='crossbar',
    fun.args = list(mult = 1),
    aes(
      x=sample_type, 
      y=!!gene_col
    ), 
    color='#20c75d'
  ) + ylim(0, max(df[gene_col])+0.5)
grid.arrange(p1, p2, nrow = 1, widths=c(2,1))

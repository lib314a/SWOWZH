# Author: Bing Li, lbing314@gmail.com
# Last changed: 11 April 2023

IN <- read.csv ("../data/SWOW-ZH_raw.csv")
dim (IN)
head (IN)

CUES <- unique(IN$cue)
OUT.R1 <- sapply (
  split (IN, IN$id),
  function (x) {
    x <- c(x$R1)
    x <- unique (x)
    sum(x%in%CUES)/length (x)
  })
OUT.R123 <- sapply (
  split (IN, IN$id),
  function (x) {
    x <- c(x$R1, x$R2, x$R3)
    x <- unique (x)
    sum(x%in%CUES)/length (x)
  })

mean (OUT.R1)
median(OUT.R1)
mean (OUT.R123)
median(OUT.R123)

library(ggplot2)
library (patchwork)

COL <- c (R1 = "#46b8da", R123 = "#357ebd")
XIN <- c (R1 = median (OUT.R1), R123 = median (OUT.R123))
P <- list (
  R1 = ggplot (data = as.data.frame (x = OUT.R1), aes (x = OUT.R1)),
  R123 = ggplot (data = as.data.frame (x = OUT.R123), aes (x = OUT.R123)))

P <- sapply (simplify = F, names(P), function (i) {
  P[[i]] +
    geom_histogram (aes (y = ..density..), binwidth = .05, fill = paste0(COL[i], "77"), color = COL[i], size = 5)+
    xlab (i)+
    ylab (c(R1 = "Density", R123 = "")[i])+
    ylim (0, 3.6)+
    geom_vline (xintercept = XIN[i], size = 5, linetype = "dashed", color = "#d43f3a99")+
    geom_text (x = XIN[i]-.1, y = c (R1 = 3.5, R123 = 3.5)[i], label = as.character (round(XIN[i], digit = 2)), size = 20, color = "#d43f3a99")+
    theme_classic ()+
    theme (
      axis.line = element_line (size = 5),
      axis.ticks = element_line (size = 5),
      axis.ticks.length = unit (-7, "mm"),
      axis.title.x = element_text (margin = margin (t = 20, b = 10, r = 0, l = 0), size = 64, face = "bold"),
      axis.title.y = element_text (margin = margin (t = 0, b = 0, r = 10, l = 10), size = 64, face = "bold"),
      axis.text.x = element_text (margin = margin (t = 25, b = 0, r = 0, l = 0), size = 56),
      axis.text.y = element_text (margin = margin (t = 0, b = 0, r = 20, l = 10), size = 56))})

with(P, R1+R123)

# Author: Bing Li, lbing314@gmail.com
# Last changed: 11 April 2023

## import the truncated unigram lexicon
## *NOTE* Please access the unigram dataset at https://catalog.ldc.upenn.edu/LDC2006T13
UNIG <- na.omit(read.delim('PATH-TO-UNIGRAM-FILE', header = F, sep = '\t'))
SWOW <- read.csv ("../data/SWOW-ZH_raw.csv")

with (UNIG,
{
  x <- V1[order (V2, decreasing = T)]
  x[!x %in% SWOW$cue][seq (100)]
})

UNIG$log.f <- log10 (UNIG$V2)
h <- hist (UNIG$log.f, breaks = 40, plot = F)
UNIG$group <- with(UNIG, cut (log.f, breaks = h$breaks, labels = h$mids, include.lowest = T))

OUT <- list ()
OUT$ratio <- sapply (split (UNIG$V1, UNIG$group), function (x) round(sum(x%in%SWOW$cue)/length (x), digit = 3))
OUT$number <- sapply (split (UNIG$V1, UNIG$group), function (x) (length (x)))
OUT$number <- round(OUT$number/max (OUT$number), digit = 3)
OUT

plot (OUT$ratio, pch = 19, xlim = c (5, 45))
lines (OUT$number, col = "#d43f3a", lwd = 3)

UNIG$covered <- UNIG$V1%in%SWOW$cue
OUT <- aggregate (data = UNIG, covered ~ group, function (x) c (yes = log10(sum (x)), no = log10(sum (!x))))

foo.unig <- with (
  OUT,{
    rbind(
      data.frame (group = group, value = covered[, "yes"], covered = "covered"),
      data.frame (group = group, value = covered[, "no"], covered = "not.covered"))
  })
foo.unig$covered <- factor (foo.unig$covered, levels = c ("not.covered", "covered"))

library (ggplot2)
ggplot(foo.unig, aes(x = group, y = value, fill = covered)) +
  geom_bar(stat = "identity", width = 1, colour = "black", size = 1.2) +
  scale_fill_manual (name = "", values = c ("#eea236", "#357ebd"), labels = c("Not in SWOW", "In SWOW")) +
  xlab ("Frequency (log)") +
  ylab ("Number of words (log)") +
  ggtitle ("SWOW/unigram coverage") +
  theme_classic () +
  theme (
    legend.position = c (.8, .8),
    plot.title = element_text (hjust = .5, size = 22, face = "bold"),
    axis.title.x = element_text (size = 18),
    axis.text.x = element_text (size = 13, angle = 90),
    axis.title.y = element_text (size = 18),
    axis.text.y = element_text (size = 15),
    axis.line = element_blank (),
    legend.text = element_text (size = 15),
    legend.key.size = unit (1, "cm")
  )

## *NOTE* Please access SUBTLEX-CH at http://crr.ugent.be/programs-data/subtitle-frequencies/subtlex-ch
SX <- read.csv("PATH-TO-SUBTLEX-LEXICON", header = F)
SX$V2 <- SX$V3
SX$V3 <- NULL
SWOW <- read.csv ("../data/SWOW-ZH_raw.csv")

with (SX,
{
  x <- V1[order (V2, decreasing = T)]
  x[!x %in% SWOW$cue][seq (100)]
})

SX$log.f <- log10 (SX$V2)
SX$group <- with(SX, {
  h <- hist (log.f, breaks = 40, plot = F)
  x <- cut (log.f, breaks = h$breaks, labels = h$mids, include.lowest = T)
}
)

OUT <- list ()
OUT$ratio <- sapply (split (SX$V1, SX$group), function (x) round(sum(x%in%SWOW$cue)/length (x), digit = 3))
OUT$number <- sapply (split (SX$V1, SX$group), function (x) (length (x)))
OUT$number <- round(OUT$number/max (OUT$number), digit = 3)
OUT

plot (OUT$ratio, pch = 19, xlim = c (0, 45))
lines (OUT$number, col = "#d43f3a", lwd = 3)

SX$covered <- SX$V1%in%SWOW$cue
OUT <- aggregate (data = SX, covered ~ group, function (x) c (yes = log10(sum (x)), no = log10(sum (!x))))

foo.sx <- with (
  OUT,{
    rbind(
      data.frame (group = group, value = covered[, "yes"], covered = "covered"),
      data.frame (group = group, value = covered[, "no"], covered = "not.covered"))
  })
foo.sx$covered <- factor (foo.sx$covered, levels = c ("not.covered", "covered"))

library (ggplot2)
ggplot(foo.sx, aes(x = group, y = value, fill = covered)) +
  geom_bar(stat = "identity", width = 1, colour = "black", size = 1.2) +
  scale_fill_manual (name = "", values = c ("#eea236", "#357ebd"), labels = c("Not in SWOW", "In SWOW")) +
  xlab ("Frequency (log)") +
  ylab ("Number of words (log)") +
  ggtitle ("SWOW/SUBTLEX coverage") +
  theme_classic () +
  theme (
    legend.position = c (.8, .8),
    plot.title = element_text (hjust = .5, size = 22, face = "bold"),
    axis.title.x = element_text (size = 18),
    axis.text.x = element_text (size = 13, angle = 90),
    axis.title.y = element_text (size = 18),
    axis.text.y = element_text (size = 15),
    axis.line = element_blank (),
    legend.text = element_text (size = 15),
    legend.key.size = unit (1, "cm")
  )

foo.sx$lexicon <- "SUBTLEX-CH"
foo.unig$lexicon <- "5-gram"
foo.unig2 <- foo.unig[as.numeric(as.character(foo.unig$group)) >= 4.1 & foo.unig$lexicon == "5-gram", ]
foo <- rbind (foo.sx, foo.unig2)

library (ggplot2)
ggplot(foo, aes(x = group, y = value, fill = covered)) +
  geom_bar(stat = "identity", width = 1, colour = "black", size = 2) +
  scale_fill_manual (name = "", values = c ("#eea236", "#357ebd"), labels = c("Not in SWOW", "In SWOW")) +
  xlab ("Frequency (log)") +
  ylab ("Number of words (log)") +
  ##ggtitle ("Frequency Coverage") +
  facet_wrap (.~lexicon, scales = "free") +
  theme_classic () +
  theme (
    ##plot.title = element_text (hjust = .5, size = 22, face = "bold"),
    axis.title.x = element_text (size = 54, face = "bold"),
    axis.text.x = element_text (size = 28, angle = 75),
    axis.title.y = element_text (size = 54, face = "bold"),
    axis.text.y = element_text (size = 36),
    axis.line = element_blank (),
    legend.position = c (.9, .8),
    legend.text = element_text (size = 42),
    legend.key.size = unit (2, "cm"),
    strip.text = element_text(size = 60, face = "bold")
  )

# Clear environment variables
rm(list = ls())

# If this package is not installed, install it first, fread function comes from this package
if (!require(data.table)) install.packages("data.table")
library(data.table)

# Set working directory, change to your own path
setwd("D:/study/caigrp/SWO-ZH_R/data")

# Initialize report structure
report <- list()

# Load data
raw <- fread("SWOW-ZH_partcleaning.csv")

# Create and populate report structure
report$inputDiscription <- data.frame(
  participants = length(unique(unlist(raw[, 3]))),
  cues = length(unique(unlist(raw[, 12]))),
  types = length(unique(unlist(raw[, 16:18]))),
  sheets = nrow(raw)
)

# Rate sheets according to priority
mark <- c('#Unknown', '#Missing')

# 3 for three responses, 2 for two responses, 1 for one response, 0 for zero responses
raw[, rate := 3 - .SD[, lapply(.SD, function(x) sum(x %in% mark)), .SDcols = 16:18][, rowSums(.SD)], by = 1:nrow(raw)]

# +0.5 if sheets are from PUTON
raw[nativeLanguage == "PUTON", rate := rate + 0.5]

# Remain 55 participants for each cue word
# First, calculate the record count for each Cue
cue_counts <- raw[, .N, by = cue]

# Calculate the deficit of records for each Cue
cue_deficit <- raw[, .(section = unique(section[section != "NAODAO"]), Deficit = max(0, 55 - .N)), by = cue]

# Filter out Cues with records reaching or exceeding 55
valid_cues <- cue_counts[N >= 55, cue]

# Filter valid Cues from the original data
raw <- raw[cue %in% valid_cues]
raw[, `:=` (Rank = rank(-rate, ties.method = "first")), by = cue]
raw <- raw[Rank <= 55, ]

# Filter out Cues with Deficit greater than 0
badcue <- cue_deficit[Deficit > 0, ]

# Sort badcue by Deficit in descending order
badcue <- badcue[order(-Deficit)]

report$badcues <- badcue

# First, calculate the count for each section
all_sections <- unlist(badcue$section)
section_freq <- data.table(section = all_sections)[, .(Count = .N), by = section]

# Then calculate the total count and percentage
total_count <- sum(section_freq$Count)
section_freq[, Percent := (Count / total_count) * 100]
report$badsets <- section_freq

report$mark$R1Missing <- sum(raw[, 16] == '#Missing')
report$mark$R2Missing <- sum(raw[, 17] == '#Missing')
report$mark$R3Missing <- sum(raw[, 18] == '#Missing')
report$mark$Unknown <- sum(raw[, 16:18] == '#Unknown')

report$ratio$R1Missing <- report$mark$R1Missing / nrow(raw)
report$ratio$R2Missing <- report$mark$R2Missing / nrow(raw)
report$ratio$R3Missing <- report$mark$R3Missing / nrow(raw)
report$ratio$Unknown <- report$mark$Unknown / (nrow(raw) * 3)
report$ratio$naN <- (report$mark$R1Missing + report$mark$R2Missing + report$mark$R3Missing + report$mark$Unknown) / (nrow(raw) * 3)

report$mark <- as.data.frame(report$mark)
report$ratio <- as.data.frame(report$ratio)

# Outputs
report$outputDiscription <- data.frame(
  participants = length(unique(unlist(raw[, 3]))),
  cues = length(unique(unlist(raw[, 12]))),
  types = length(unique(unlist(raw[, 16:18]))),
  sheets = nrow(raw)
)
# Save raw data
raw <- raw[, .SD, .SDcols = 1:18]

write.csv(raw, 'SWOW-ZH_R55.csv', row.names = FALSE)
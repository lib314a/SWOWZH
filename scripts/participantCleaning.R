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
raw <- fread("SWOW-ZH_wordcleaning.csv")
englishRes <- fread("dictionaries/englishRes.csv")
ch <- fread("dictionaries/SWOWZHwordlist.csv")

# Create and fill report structure
report$inputDiscription <- data.frame(
  participants = length(unique(unlist(raw[, 3]))),
  cues = length(unique(unlist(raw[, 12]))),
  types = length(unique(unlist(raw[, 16:18]))),
  sheets = nrow(raw)
)

# Reorganize SWOW-ZH according to participants index
partdic <- unlist(unique(raw[,3])) # remains the order in the original array
dic <- unlist(raw[,3])

part <- vector("list", length(partdic))

for (i in 1:length(partdic)) {
  idx <- which(dic == partdic[i])
  part[[i]] <- list(
    participant_id = raw[idx[1], 3]$participantID,
    responses = raw[idx, 12:18],
    combined_responses = unlist(raw[idx, 16:18])
  )
}

# Too many non-words responses (> 40%)
pNonword <- list()
count <- 0

# Get the intersection of columns 16 to 18 of raw with ch
ch_intersect <- intersect(as.character(unlist(raw[, 16:18])), unlist(ch))

for (i in 1:length(part)) {
  idxm <- which(part[[i]][[3]] == '没有了')
  idxu <- which(part[[i]][[3]] == 'Unknown word')
  idxb <- which(part[[i]][[3]] == '不认识')
  idxs <- which(part[[i]][[3]] == '#Symbol')
  idxl <- which(part[[i]][[3]] == '#Long')
  idxrr <- which(part[[i]][[3]] == '#Repeat')

  idxtag <- c(idxm, idxu, idxb, idxs, idxl, idxrr)
  idxword <- setdiff(1:length(part[[i]][[3]]), idxtag)

  ins <- intersect(part[[i]][[3]][idxword], unlist(ch_intersect))

  if (length(ins) > 0) {
    if (length(ins) / length(idxword) < 0.6) {
      count <- count + 1
      pNonword[[count]] <- part[[i]]
    }
  } else {
    count <- count + 1
    pNonword[[count]] <- part[[i]]
  }
}

report$participantsDelete$Nonword <- length(pNonword)

# Too many long-string responses (> 30%)
pLong <- list()
count <- 0

for (i in 1:length(part)) {
  idx <- which(part[[i]][[3]] == '#Long')

  if (length(idx) > 0) {
    if (length(idx) / length(part[[i]][[3]]) > 0.3) {
      count <- count + 1
      pLong[[count]] <- part[[i]]
    }
  }
}

report$participantsDelete$Long <- length(pLong)

# Too many symbol responses (> 40%)
pSymbol <- list()
count <- 0
for (i in seq_along(part)) {
  idx <- which(part[[i]][[3]] == '#Symbol')
  if (length(idx) > 0) {
    if (length(idx) / length(part[[i]][[3]]) > 0.4) {
      count <- count + 1
      pSymbol[[count]] <- part[[i]]
    }
  }
}
report$participantsDelete$Symbol <- length(pSymbol)

# Too many English responses (> 40%)
pEnglish <- list()
count <- 0
for (i in seq_along(part)) {
  intersection <- list()
  # Use intersect to calculate the intersection (deduplicate)
  intersection <- intersect(part[[i]][[3]], unlist(englishRes[,1]))
  # Use the table() function to calculate the frequency of each element in the original vector
  counts_part <- table(part[[i]][[3]])
  # Use the sum() function to calculate the total frequency of intersection elements in part[[i]][[3]]
  intersection_size <- sum(counts_part[intersection])
  if (intersection_size > 0) {
    if (intersection_size / length(part[[i]][[3]]) > 0.4) {
      count <- count + 1
      pEnglish[[count]] <- part[[i]]
    }
  }
}
report$participantsDelete$English <- length(pEnglish)

# Too many repeated responses (> 20%) 
# Too many "Unknown Word" and "Missing" responses (> 60%)
pEmpty <- list()
pRepeat <- list()
countE <- 0
countR <- 0
for (i in seq_along(part)) {
  idxm <- which(part[[i]][[3]] == '没有了')
  idxu <- which(part[[i]][[3]] == 'Unknown word')
  idxb <- which(part[[i]][[3]] == '不认识')
  idx <- c(idxm, idxu, idxb)
  if (length(idx) > 0) {
    if (length(idx) / length(part[[i]][[3]]) > 0.6) {
      countE <- countE + 1
      pEmpty[[countE]] <- part[[i]]
    }
  }
  idxs <- which(part[[i]][[3]] == '#Symbol')
  idxl <- which(part[[i]][[3]] == '#Long')
  idxrr <- which(part[[i]][[3]] == '#Repeat')
  idx <- c(idx, idxs, idxl, idxrr)
  idxr <- setdiff(seq_along(part[[i]][[3]]), idx)
  repeatnum <- length(part[[i]][[3]][idxr]) - length(unique(part[[i]][[3]][idxr]))
  if ((repeatnum + length(idxrr)) / length(part[[i]][[3]]) > 0.2) {
    countR <- countR + 1
    pRepeat[[countR]] <- part[[i]]
  }
}
report$participantsDelete$Repeat <- length(pRepeat)
report$participantsDelete$Empty <- length(pEmpty)

# Cantonese participants
idxcan <- which(raw[, 6] == "SOUTH")
pCantonese <- unique(raw[idxcan, 3])
# For each element in the list part, use the [[ function to extract its first sub-element.

participantIDs <- sapply(part, `[[`, 1)
intersection <- intersect(unlist(pCantonese), participantIDs)
# Find the index of elements in intersection in participantIDs
idx <- match(intersection, participantIDs)
pCantonese <- part[idx]

report$participantsDelete$Cantonese <- length(pCantonese)

report$participantsDelete <- as.data.frame(report$participantsDelete)

# Remove participants
dic <- unique(c(sapply(pNonword, `[[`, 1), 
                sapply(pLong, `[[`, 1), 
                sapply(pSymbol, `[[`, 1), 
                sapply(pEnglish, `[[`, 1), 
                sapply(pRepeat, `[[`, 1), 
                sapply(pEmpty, `[[`, 1), 
                sapply(pCantonese, `[[`, 1)))

report$participantsDeleteActually <- length(dic)

idx <- which(unlist(raw[, 3]) %in% dic)
raw <- raw[-idx, ]

# Transform "不认识" "没有了" "Unknown word" to #Missing or #Unknown
for (i in seq_len(nrow(raw))) {
  line <- unlist(raw[i, 16:18])
  
  # Check if all elements meet a certain condition
  if (all(line == '不认识') || all(line == 'Unknown word')) {
    raw[i, 16:18 := list('#Unknown', '#Unknown', '#Unknown')]
  } else if (all(line == '没有了')) {
    raw[i, 16:18 := list('#Missing', '#Missing', '#Missing')]
  } else if (all(line[2:3] == '没有了')) {
    raw[i, 17:18 := list('#Missing', '#Missing')]
  } else if (line[3] == '没有了' && line[1] != '没有了') {
    raw[i, 18 := '#Missing']
  }
}

# Transform other tags to #Missing
report$mark$Repeat_sameSheet <- sum(raw[, 16:18] == '#Repeat')
report$mark$Symbol <- sum(raw[, 16:18] == '#Symbol')
report$mark$Long <- sum(raw[, 16:18] == '#Long')

tags <- c('#Symbol', '#Long', '#Repeat')
raw[, `:=`(R1 = ifelse(R1 %in% c("#Symbol", "#Long", "#Repeat"), "#Missing", R1),
          R2 = ifelse(R2 %in% c("#Symbol", "#Long", "#Repeat"), "#Missing", R2),
          R3 = ifelse(R3 %in% c("#Symbol", "#Long", "#Repeat"), "#Missing", R3))]

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
# save raw data  
write.csv(raw, 'SWOW-ZH_partcleaning.csv', row.names = FALSE)
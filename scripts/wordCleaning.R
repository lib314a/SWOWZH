# Clear environment variables
rm(list = ls())

# If this package is not installed, install it first. The fread function comes from this package.
if (!require(data.table)) install.packages("data.table")
library(data.table)

# Set the working directory (please replace with your actual path)
setwd("../data")

# Initialize report structure
report <- list()

# Load data
raw <- fread("SWOW-ZH_raw.csv")
tradCues <- fread("dictionaries/tradCues.csv")
tradRes <- fread("dictionaries/tradRes.csv")
englishRes <- fread("dictionaries/englishRes.csv")
erRes <- fread("dictionaries/erRes.csv")
longRes <- fread("dictionaries/longRes.csv")
unsplitedRes <- fread("dictionaries/unsplitedRes.csv")
symbolRes <- fread("dictionaries/symbolRes.csv")

raw[, `:=`(R1 = R1Raw, R2 = R2Raw, R3 = R3Raw)]
# Add an index column to the raw data table, with values as row numbers
raw[, index := .I]

# Create and populate report structure
report$inputDiscription <- data.frame(
  participants = length(unique(unlist(raw[, 3]))),
  cues = length(unique(unlist(raw[, 12]))),
  types = length(unique(unlist(raw[, 16:18]))),
  sheets = nrow(raw)
)

# Define a general processing function
processData <- function(data, processFunc, filterRes, reportKey) {
  # Initialize
  result <- list()
  
  # Loop through R1, R2, R3 for processing
  for (col in c("R1", "R2", "R3")) {
    result <- processFunc(data, filterRes, col, result)
  }
  
  # Update the data table
  data[result$index, (16:18) := .(result$R1, result$R2, result$R3)]
  
  # Update the global variable report
  report$sheetsChange[[reportKey]] <<- nrow(result)
  
  return(result)
}

# Response data cleaning: symbolRes (tag: #Symbol)
process_symbol <- function(data, symbolRes, col, result) {
  # Update the specified column based on symbolRes
  if (col == "R1") {
    temp <- data[symbolRes, on = .(R1 = symbolRes1), nomatch = 0]
    result <- temp[, .(index, symbolRes2, R2, R3)]
    setnames(result, "symbolRes2", col)
  } else {
    if (col == "R2") {
      temp <- data[symbolRes, on = .(R2 = symbolRes1), nomatch = 0]
      temp <- temp[, .(index, R1, symbolRes2, R3)]
      setnames(temp, "symbolRes2", col)
      # If index already exists, update R2
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R2 := temp$R2, mult = "first"]
    } else if (col == "R3") {
      temp <- data[symbolRes, on = .(R3 = symbolRes1), nomatch = 0]
      temp <- temp[, .(index, R1, R2, symbolRes2)]
      setnames(temp, "symbolRes2", col)
      # If index already exists, update R3
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R3 := temp$R3, mult = "first"]
    }
    # If the index in temp does not exist in result, add the entire row
    result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
  }
  return(result)
}

# Call processData function to handle rSymbol
rSymbol <- processData(raw, process_symbol, symbolRes, "Symbol")

# Response data cleaning: unsplitedRes
# Define process_Unsplited function
process_unsplited <- function(data, unsplitedRes, col, result) {
  # Update the specified column based on unsplitedRes
  if (col == "R1") {
    temp <- data[unsplitedRes, on = .(R1 = unsplitedRes1), nomatch = 0]
    # Organize lines
    temp[, lines := mapply(function(res, r2, r3) {
      c(strsplit(res, ",")[[1]], r2, r3)
    }, unsplitedRes2, R2, R3, SIMPLIFY = FALSE)]
  } else {
    if (col == "R2") {
      temp <- data[unsplitedRes, on = .(R2 = unsplitedRes1), nomatch = 0]
      # Organize lines
      temp[, lines := mapply(function(idx, r1, res, r3) {
        # Check if index is in result's index
        r1_selected <- ifelse(idx %in% result$index,
          list(result[index == idx, .(R1, R2, R3)]), # Get R1 from result
          r1
        ) # Get R1 from temp
        c(unlist(r1_selected), strsplit(res, ",")[[1]], r3)
      }, temp$index, temp$R1, temp$unsplitedRes2, temp$R3, SIMPLIFY = FALSE)]
    }else if (col == "R3") {
      temp <- data[unsplitedRes, on = .(R3 = unsplitedRes1), nomatch = 0]

      # Organize lines column, split strings and handle indexes already in result
      temp[, lines := mapply(function(idx, r1, r2, res) {
        # Check if index is in result's index
        r1_r2_selected <- if (idx %in% result$index) {
          unlist(result[index == idx, .(R1, R2, R3)])
          } else {
            c(r1, r2)
          }
        # Concatenate R1, R2 and split res
        c(r1_r2_selected, strsplit(res, ",")[[1]])
      }, index, temp$R1, temp$R2, temp$unsplitedRes2, SIMPLIFY = FALSE)]
    }
  }
    # Update R1, R2, R3 columns
    temp[, `:=`(
      R1 = sapply(lines, function(x) x[1]), # The first element after splitting
      R2 = sapply(lines, function(x) x[2]), # The second element (original R2)
      R3 = sapply(lines, function(x) x[3]) # The third element (original R3)
    )]
    temp <- temp[, .(index, R1, R2, R3)]
    if(col == "R1"){
      result <- temp
    }else if(col == "R2" || col == "R3"){
      # If index already exists, update R1, R2, R3, otherwise add the entire row to result
      result[temp,on = .(index = index),c("R1", "R2", "R3") := .(i.R1, i.R2, i.R3),mult = "first"]
      # If temp's index does not exist in result, add the entire row
      result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
    }
  return(result)
}

# Call processData function to handle rSplit
rSplit <- processData(raw, process_unsplited, unsplitedRes, "Unsplited")

# Response data cleaning: longRes (tag: #Long)
process_long <- function(data, longRes, col, result) {
  # Update the specified column based on longRes
  if (col == "R1") {
    temp <- data[longRes, on = .(R1 = longRes1), nomatch = 0]
    result <- temp[, .(index, longRes2, R2, R3)]
    setnames(result, "longRes2", "R1")
  } else {
    if (col == "R2") {
      temp <- data[longRes, on = .(R2 = longRes1), nomatch = 0]
      temp <- temp[, .(index, R1, longRes2, R3)]
      setnames(temp, "longRes2", col)
      # If index already exists, update R2
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R2 := temp$R2, mult = "first"]
    } else if (col == "R3") {
      temp <- data[longRes, on = .(R3 = longRes1), nomatch = 0]
      temp <- temp[, .(index, R1, R2, longRes2)]
      setnames(temp, "longRes2", col)
      # If index already exists, update R3
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R3 := temp$R3, mult = "first"]
    }
    # If temp's index does not exist in result, add the entire row
    result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
  }
  return(result)
}

# Call processData function to handle 
rLong <- processData(raw, process_long, longRes, "Long")

# Response data cleaning: englishRes
process_en <- function(data, englishRes, col, result) {
  # Update the specified column based on englishRes
  if (col == "R1") {
    temp <- data[englishRes, on = .(R1 = englishRes1), nomatch = 0]
    result <- temp[, .(index, englishRes2, R2, R3)]
    setnames(result, "englishRes2", col)
  } else {
    if (col == "R2") {
      temp <- data[englishRes, on = .(R2 = englishRes1), nomatch = 0]
      temp <- temp[, .(index, R1, englishRes2, R3)]
      setnames(temp, "englishRes2", col)
      # If index already exists, update R2
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R2 := temp$R2, mult = "first"]
    } else if (col == "R3") {
      temp <- data[englishRes, on = .(R3 = englishRes1), nomatch = 0]
      temp <- temp[, .(index, R1, R2, englishRes2)]
      setnames(temp, "englishRes2", col)
      # If index already exists, update R3
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R3 := temp$R3, mult = "first"]
    }
    # If temp's index does not exist in result, add the entire row
    result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
  }
  return(result)
}

# Call processData function to handle 
rEn <- processData(raw, process_en, englishRes, "English")

# Cue words cleaning: Traditional Chinese
# Cue words
process_tradCues <- function(data, tradCues) {
  # Update the specified column based on tradCues
  result <- list()
  temp <- data[tradCues, on = .(cue = tradCues1), nomatch = 0]
  result <- temp[, .(index, tradCues2)]
  setnames(result, "tradCues2", "cue")
  return(result)
}


cTrad <- process_tradCues(raw, tradCues)

# Update the data table
raw[cTrad$index, 12 := cTrad$cue]

# Update the global variable report
report$sheetsChange$Tradcues <- nrow(cTrad)

# Responses cleaning: Traditional Chinese
process_tradRes <- function(data, tradRes, col, result) {
  # Update the specified column based on symbolRes
  if (col == "R1") {
    temp <- data[tradRes, on = .(R1 = tradRes1), nomatch = 0]
    result <- temp[, .(index, tradRes2, R2, R3)]
    setnames(result, "tradRes2", col)
  } else {
    if (col == "R2") {
      temp <- data[tradRes, on = .(R2 = tradRes1), nomatch = 0]
      temp <- temp[, .(index, R1, tradRes2, R3)]
      setnames(temp, "tradRes2", col)
      # If index already exists, update R2
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R2 := temp$R2, mult = "first"]
    } else if (col == "R3") {
      temp <- data[tradRes, on = .(R3 = tradRes1), nomatch = 0]
      temp <- temp[, .(index, R1, R2, tradRes2)]
      setnames(temp, "tradRes2", col)
      # If index already exists, update R3
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R3 := temp$R3, mult = "first"]
    }
    # If temp's index does not exist in result, add the entire row
    result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
  }
  return(result)
}

# Call processData function to handle 
rTrad <- processData(raw, process_tradRes, tradRes, "Tradres")

# Response data cleaning: erRes (Erhua)
process_er <- function(data, erRes, col, result) {
  # Update the specified column based on symbolRes
  if (col == "R1") {
    temp <- data[erRes, on = .(R1 = erRes1), nomatch = 0]
    result <- temp[, .(index, erRes2, R2, R3)]
    setnames(result, "erRes2", col)
  } else {
    if (col == "R2") {
      temp <- data[erRes, on = .(R2 = erRes1), nomatch = 0]
      temp <- temp[, .(index, R1, erRes2, R3)]
      setnames(temp, "erRes2", col)
      # If index already exists, update R2
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R2 := temp$R2, mult = "first"]
    } else if (col == "R3") {
      temp <- data[erRes, on = .(R3 = erRes1), nomatch = 0]
      temp <- temp[, .(index, R1, R2, erRes2)]
      setnames(temp, "erRes2", col)
      # If index already exists, update R3
      result <- result[temp, on = .(index = index), allow.cartesian = TRUE, R3 := temp$R3, mult = "first"]
    }
    # If temp's index does not exist in result, add the entire row
    result <- rbindlist(list(result, temp[!index %in% result$index]), use.names = TRUE, fill = TRUE)
  }
  return(result)
}

# Call processData function to handle 
rEr <- processData(raw, process_er, erRes, "Er")

# Response data cleaning: repeatRes (tag: #Repeat)
# List of specific strings
specialStrings <- c('没有了', 'Unknown word', '不认识', '#Symbol', '#Long')

# Iterate through rows, marking repeated values (except the first occurrence) as '#Repeat', ignoring values of specific strings
raw[, (c("R1", "R2", "R3")) := {
  # Get the current row's R1, R2, R3 column values
  vals <- .SD
  # Convert columns to a vector
  vals_vec <- unlist(vals, use.names = FALSE)
  # Initialize a vector of the same length as vals_vec to store processed values
  processed_vals <- vals_vec
  
  # Process each unique value, ignoring values of specific strings
  for (val in unique(vals_vec[!vals_vec %in% specialStrings])) {
    # Find all positions of the current value in the vector
    positions <- which(vals_vec == val)
    # If the value appears more than once, mark all but the first occurrence as '#Repeat'
    if (length(positions) > 1) {
      processed_vals[positions[-1]] <- "#Repeat"
    }
  }
  
  # Reassign the processed vector back to R1, R2, R3
  list(processed_vals[1], processed_vals[2], processed_vals[3])
}, by = .I, .SDcols = c("R1", "R2", "R3")]

# Calculate the number of rows where '#Repeat' appears at least once
repeatCount <- raw[, .(HasRepeat = any(R1 == "#Repeat" | R2 == "#Repeat" | R3 == "#Repeat")), by = .I][, sum(HasRepeat)]

# Update report
report$sheetsChange$Repeat <- repeatCount

# Convert report$sheetsChange to a data frame
report$sheetsChange <- as.data.frame(report$sheetsChange)

# Count the occurrences of #Symbol
symbol_count <- sum(raw[, 16:18] == "#Symbol")
report$mark$Symbol <- symbol_count

# Count the occurrences of #Long
long_count <- sum(raw[, 16:18] == "#Long")
report$mark$Long <- long_count

# Count the occurrences of #Repeat
repeat_count <- sum(raw[, 16:18] == "#Repeat")
report$mark$Repeat_sameSheet <- repeat_count

# Convert report$mark to a data frame
report$mark <- as.data.frame(report$mark)


# Save the cleaned data back to a file
# Outputs
report$outputDiscription <- data.frame(
  participants = nrow(unique(raw[, 3])),
  cues = nrow(unique(raw[, 12])),
  types = length(unique(unlist(raw[, 16:18]))),
  sheets = nrow(raw)
)

raw <- raw[, .SD, .SDcols = 1:18]

# Save raw to CSV file
write.csv(raw, file = "SWOW-ZH_wordcleaning.csv", row.names = FALSE)

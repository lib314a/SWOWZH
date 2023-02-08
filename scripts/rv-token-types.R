IN <- read.csv ("../data/SWOW-ZH_raw.csv")

## Convert to long format and translate British to American or remove British ones if American exists
importDataSWOW <- function(dataInput,response) {
  ## Convert to a long (tall) format
  X       = gather(dataInput[c ("cue", "R1", "R2", "R3")] ,RPOS,response,R1,R2,R3,factor_key = FALSE)

  ##  # Remove the brexit words
  ##  X       = brexitWords(X)

  ## Decide which responses to keep
  switch(response,
    R1 = { X = filter(X,RPOS =='R1') },
    R2 = { X = filter(X,RPOS =='R2') },
    R3 = { X = filter(X,RPOS =='R3') },
    R12 = { X = filter(X,RPOS %in% c('R1','R2')) },
    R123 = { X = X })

  X <- X[X$response != "#Missing",]
  return(X)
}

require(tidyverse)
require(svglite)
require(zipfR)

# Derive the vocabulary growth curve
getVGC = function(response){
  n         = ceiling(nrow(response)/10000)
  V         = rep(1,n)
  for (i in 1:n){
    rn = 10000*i
    V[i] =  nrow(
      filter(response,between(row_number(),1,rn)) %>%
      group_by(response) %>%
      summarise(Freq = n()))
  }
  response.vgc   = vgc(N = (1:n)*10000,V = V)
  return(response.vgc)
}

## Load data and shuffle response order
X.R1              = importDataSWOW(IN,'R1')
names(X.R1) <- c("cue", "RPOS", "response")
X.R1              = X.R1 %>% filter(!is.na(response))
X.R1$response     = X.R1$response[sample(nrow(X.R1))]

# Do the same thing for R123
X.R123            = importDataSWOW(IN,'R123')
names(X.R123) <- c("cue", "RPOS", "response")
X.R123            = X.R123 %>% filter(!is.na(response))
X.R123$response   = X.R123$response[sample(nrow(X.R123))]

saveRDS (X.R1, file = "rv-token-types-OUT-XR1.rds")
saveRDS (X.R123, file = "rv-token-types-OUT-XR123.rds")

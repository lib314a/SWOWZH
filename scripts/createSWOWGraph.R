# Description:
#
# Load Mandarin Chinese Small world of words data (https://smallworldofwords.org/)
#
# For each cue a total of 165 (55*3) responses are available, consisting of 55 first, 55 second and 55 third responses
#
# The edge weights in the unimodal graph G.raw
# correspond to associative strength p(response|cue) after removing missing and unknown word responses
#
# Note: the data included with this script cannot be distributed without prior consent
# The same function achieved in MATLAB pipeline is "networkGeneration.m"
#
# Author: Simon De Deyne simon2d@gmail.com
# Adapted for Mandarin Chinese processing: Ziyi Ding (ziyi.ecnu@gmail.com)
# Last changed: 11 April 2023

setwd('C:/Users/Ziyi Ding/Desktop/SWOWZH Rpipeline') 

library('igraph')
library('Matrix')

results = list()

output.file         = './output/adjacencyMatrices/SWOW-ZH.'
report.file         = './output/reports/components.SWOW-ZH.rds'

source('./R/functions/importDataFunctions.R')
source('./R/functions/networkFunctions.R')


# Import the dataset for R1
dataFile          = './data/SWOW-ZH_R55.csv'
response          = 'R1' # Options: R1, R2, R3 or R123
X.R1              = importDataSWOW(dataFile,response)

# Extract unimodal graph (strong component)
G.R1              = createGraph(X.R1)
compResults.R1    = extractComponent(G.R1,'strong')
G.R1.strong       = compResults.R1$subGraph

results$R1$removeVertices = compResults.R1$removedVertices
results$R1$maxSize = compResults.R1$maxSize

# Write adjacency and label files for G.raw
writeAdjacency(G.R1.strong, paste(output.file,response,sep=''))

# Import the dataset for R123
response          = 'R123' # Options: R1, R2, R3 or R123
X.R123            = importDataSWOW(dataFile,response)

# Extract unimodal graph (strong component)
G.R123            = createGraph(X.R123)
compResults.R123  = extractComponent(G.R123,'strong')
G.R123.strong     = compResults.R123$subGraph
results$R123$removeVertices = compResults.R123$removedVertices
results$R123$maxSize = compResults.R123$maxSize



# Write weighted adjacency file
writeAdjacency(G.R123.strong, paste(output.file,response,sep=''))

# Write a summary of the output to an rds file
saveRDS(results,report.file,ascii=TRUE)

# Clean up
rm(list = ls())

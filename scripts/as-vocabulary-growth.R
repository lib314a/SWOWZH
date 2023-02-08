## Convert to long format and translate British to American or remove British ones if American exists
importDataSWOW <- function(dataFile,response) {
  X       = read.csv(dataFile, header = TRUE, sep=",", dec=".",quote = "\"",encoding = "UTF-8",stringsAsFactors = FALSE)

  ## Convert to a long (tall) format
  X       = gather(X,RPOS,response,R1,R2,R3,factor_key = FALSE)

  ##  # Remove the brexit words
  ##  X       = brexitWords(X)

  ## Decide which responses to keep
  switch(response,
    R1 = { X = filter(X,RPOS =='R1') },
    R2 = { X = filter(X,RPOS =='R2') },
    R3 = { X = filter(X,RPOS =='R3') },
    R12 = { X = filter(X,RPOS %in% c('R1','R2')) },
    R123 = { X = X })

  return(X)
}

## Settings ——————————————
library("ggplot2")
library("tidyverse")
library("zipfR")
##library("ggnewscale")
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

## Type-token ——————————————
X.R1 = readRDS("./rv-token-types-OUT-XR1.rds")
X.R123 =readRDS("./rv-token-types-OUT-XR123.rds")
# Obtain a frequency spectrum
R1.F          = X.R1 %>%  group_by(response) %>% summarise(Freq = n()) %>% group_by(Freq) %>% summarise(FF = n())
R1.spc        = spc(Vm = R1.F$FF,m=R1.F$Freq)
# Fit the finite zipfian mandelbrot model
R1.fzm        = lnre("fzm", R1.spc, exact = FALSE)
R1.fzm.spc    = lnre.spc(R1.fzm, N(R1.fzm))
summary(R1.fzm)
# Obtain a frequency spectrum
R123.F        = X.R123 %>%  group_by(response) %>% summarise(Freq = n()) %>% group_by(Freq) %>% summarise(FF = n())
R123.spc      = spc(Vm = R123.F$FF,m=R123.F$Freq)
R123.fzm      = lnre("fzm", R123.spc, exact = TRUE,verbose = TRUE,m.max=11)
R123.fzm.spc  = lnre.spc(R123.fzm, N(R123.fzm))
summary(R123.fzm)
# Obtain empirical growth curve
R1.vgc        = getVGC(X.R1)
R123.vgc      = getVGC(X.R123)
# Plot the empirical VGC against the estimated curve for a maximum of k responses
k             = 1.5e6
n.R1          = ceiling(nrow(X.R1)/1000)
n.R123        = ceiling(nrow(X.R123)/1000)

R1.fzm.vgc    = lnre.vgc(R1.fzm, (1:n.R1) * ceiling(k/n.R1))
R123.fzm.vgc  = lnre.vgc(R123.fzm, (1:n.R123) * ceiling(k/n.R123))
R1.fzm.vgc$label = c(rep("Zipf-Mandelbrot R1",nrow(R1.fzm.vgc)))
R1.vgc$label = c(rep("Observed R1",nrow(R1.vgc)))
R123.fzm.vgc$label = c(rep("Zipf-Mandelbrot R123",nrow(R123.fzm.vgc)))
R123.vgc$label = c(rep("Observed R123",nrow(R123.vgc)))
tt = rbind(R1.fzm.vgc, R1.vgc)
tt = rbind(tt, R123.fzm.vgc)
tt = rbind(tt, R123.vgc)
tt$label = ordered(tt$label, levels = c('Zipf-Mandelbrot R1','Observed R1',
                                        'Zipf-Mandelbrot R123','Observed R123'))

COLOR.1 <- "#46b8da"
COLOR.2 <- "#357ebd"

ggplot(data = tt, mapping = aes(x = N, y = V, color = label, linetype = label)) +
  geom_line(size = 2) + 
  scale_color_manual(name = " ",
                     values = c("gray77",COLOR.1,"gray49",COLOR.2),
                     labels = c('Zipf-Mandelbrot R1','Observed R1',
                                'Zipf-Mandelbrot R123','Observed R123')) +
  scale_linetype_manual(name = " ",
                        values = c("solid","longdash","solid","longdash"),
                        labels = c('Zipf-Mandelbrot R1','Observed R1',
                                   'Zipf-Mandelbrot R123','Observed R123')) +
  labs(x = "Number of tokens", y = "Number of types") + 
  guides(color = guide_legend(title = NULL)) +
  guides(linetype = guide_legend(title = NULL)) +
  scale_y_continuous(limits = c(0,1.4*10^5), breaks = seq(0,1.4*10^5,2*10^4),
                     label = c(0,expression(paste('2×10')^4),expression(paste('4×10')^4),expression(paste('6×10')^4),
                               expression(paste('8×10')^4),expression(paste('10×10')^4),expression(paste('12×10')^4),
                               expression(paste('14×10')^4))) +
  scale_x_continuous(limits = c(0,1.8*10^6), breaks = seq(0,1.6*10^6,0.4*10^6),
                     label = c(0,expression(paste('4×10')^5),expression(paste('8×10')^5),expression(paste('12×10')^5),
                               expression(paste('16×10')^5))) +
  geom_vline(xintercept = N(R1.fzm), 
             size = 2, color = COLOR.1, linetype = "longdash", show.legend = FALSE) +
  geom_vline(aes(xintercept = N(R123.fzm)), 
             size = 2, color = COLOR.2, linetype = "longdash", show.legend = FALSE) +
  theme_classic() +
  theme(
    legend.position = c(.6,.25),
    legend.text = element_text(size = 24),
    legend.key.size = unit(1, "cm"),
    axis.title.x = element_text(size = 28, face = "bold"),
    axis.title.y = element_text(size = 28, face = "bold"),
    axis.text.x = element_text(size = 20),
    axis.text.y = element_text(size = 20)
  )

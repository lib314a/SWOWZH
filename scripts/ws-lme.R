## -----------------------------------------------------------------------------
## the LDT task
library (lme4)
IN <- read.csv ("../data/LDTprediction_originalData.csv")
IN$PoS <- factor(IN$PoS)
IN$length <- ordered (IN$length)
IN$strokes <- apply (IN[, grep (names (IN), pat = "C[0-9]stroke")], 1, sum, na.rm = T)

lapply (IN[, c("logzRT", "PoS", "length", "logtextwf", "logdiawf", "logcd", "logindegree_unw_R1", "logindegree_unw_R123", "strokes")], summary)

M <- lmer (
  logzRT ~
    (
      1
      + logindegree_unw_R123
      ##+ logcd
      | PoS
    ) + (
      1
      | length
    ) +
    logtextwf+
    logdiawf+
    logcd+
    ##logindegree_unw_R1+
    logindegree_unw_R123
, data = IN)
summary (M)

OUT <- parallel::mclapply(
                   c(
                     dialogue.word.frequency = "logdiawf",
                     context.diversity = "logcd",
                     text.word.frequency = "logtextwf",
                     ##R1.indegree = "logindegree_unw_R1",
                     SWOW.indegree = "logindegree_unw_R123"),
                   function (x) anova (M, update (M, paste0("~. -", x))),
                   mc.cores = 5
                 )

do.call(rbind, lapply (
                 names(OUT),
                 function (i) {
                   x <- OUT[[i]]
                   data.frame (
                     main.effect = i,
                     LRT.Chisq = round(x$Chisq[2], digit = 3),
                     LRT.Pr = round (x$Pr[2], digit = 3)
                   )
                 }
               ))

IN <- readRDS(file = "ws-lme-IN-naming.rds")
table(sapply(IN$words, nchar))
summary (IN)

round(cor (IN[, c ("first_swowR1_max", "behind_swowR1_max","all_swowR1_max", "logindegree_unw_R1",
                   "first_swowR123_max", "behind_swowR123_max", "all_swowR123_max", "logindegree_unw_R123")]), digit = 3)

## -----------------------------------------------------------------------------
## the naming task
library (lme4)

IN <- read.csv ("../results/Nprediction_JASP.csv")
IN$PoS <- factor (IN$PoS)

M <- lmer (
  logzRT ~
    (
      1
      | PoS
    ) +
    logtextwf +
    logdiawf_C +
    logcd_C,
  ##first_swowR1_max +
  ##behind_swowR1_max +
  ##all_swowR1_max +
  ##logindegree_unw_R1 +
  ##all_swowR123_max +
  ##logindegree_unw_R123 +
  ##first_swowR123_max +
  ##behind_swowR123_max,
  data = IN
)
summary (M)
anova (M)

M <- lm (
  logzRT ~
    logtextwf +
    logdiawf_C +
    logcd_C,
  data = IN
)
summary (M)
anova (M)

R2 <- summary (M)$adj.r.squared
OUT <- parallel::mclapply(
                   c(
                     text.word.frequency = "logtextwf",
                     dialogue.word.frequency = "logdiawf_C",
                     context.diversity = "logcd_C"
                   ),
                   function (x) {
                     m <- update (M, paste0("~. -", x))
                     y <- anova (M, m)
                     y$delta.r2 <- R2 - summary (m)$adj.r.squared
                     y
                   },
                   mc.cores = 5
                 )

do.call(rbind, lapply (
                 names(OUT),
                 function (i) {
                   x <- OUT[[i]]
                   data.frame (
                     main.effect = i,
                     Fstatistic = round(x$F[2], digit = 3),
                     Pr = round (x$Pr[2], digit = 3),
                     delta.r2 = round (x$delta.r2[2], digit = 3)
                   )
                 }
               ))

R2 <- summary (M)$adj.r.squared
OUT <- parallel::mclapply(
                   c(
                     SWOWR1.p1 = "first_swowR1_max",
                     SWOWR1.p2 = "behind_swowR1_max",
                     SWOWR1.pn = "all_swowR1_max",
                     SWOWR1 = "logindegree_unw_R1",
                     SWOWR123.p1 = "first_swowR123_max",
                     SWOWR123.p2 = "behind_swowR123_max",
                     SWOWR123.pn = "all_swowR123_max",
                     SWOWR123 = "logindegree_unw_R123"
                   ),
                   function (x) {
                     m <- update (M, paste0("~. +", x))
                     y <- anova (M, m)
                     y$delta.r2 <- summary (m)$adj.r.squared - R2
                     y
                   },
                   mc.cores = 5
                 )

do.call(rbind, lapply (
                 names(OUT),
                 function (i) {
                   x <- OUT[[i]]
                   data.frame (
                     main.effect = i,
                     Fstatistic = round(x$F[2], digit = 3),
                     Pr = round (x$Pr[2], digit = 3),
                     delta.r2 = round (x$delta.r2[2], digit = 3)
                   )
                 }
               ))

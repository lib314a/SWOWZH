
# Table of Contents

1.  [lexical decision](#orgaa2c8bd)
2.  [naming](#org55111ca)



<a id="orgaa2c8bd"></a>

# lexical decision

Read the formatted data

    library (lme4)
    IN <- readRDS ("/home/lbing/experiments/SWOWCN/ws-lme-IN-ldt.rds")
    lapply (IN[, c("logzRT", "PoS", "length", "logtextwf", "logdiawf", "logcd", "logindegree_unw_R1", "logindegree_unw_R123", "strokes")], summary)

    $logzRT
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
     0.0000  0.1285  0.1649  0.1694  0.2053  0.4295 
    
    $PoS
       0    1    2    3    4    5 
    1456 2198  577  332   18    5 
    
    $length
       1    2    3    4 
     209 4198  153   26 
    
    $logtextwf
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      5.027   6.482   6.915   6.998   7.488   9.221 
    
    $logdiawf
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      0.000   1.978   2.456   2.464   2.924   5.570 
    
    $logcd
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      0.000   1.851   2.292   2.283   2.722   3.795 
    
    $logindegree_unw_R1
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
     0.3010  0.9031  1.1461  1.1656  1.4150  2.6839 
    
    $logindegree_unw_R123
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      0.301   1.301   1.556   1.581   1.833   3.001 
    
    $strokes
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       3.00   13.00   16.00   16.51   20.00   42.00

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

    Linear mixed model fit by REML ['lmerMod']
    Formula: logzRT ~ (1 + logindegree_unw_R123 | PoS) + (1 | length) + logtextwf +      logdiawf + logcd + logindegree_unw_R123
       Data: IN
    
    REML criterion at convergence: -14969.1
    
    Scaled residuals: 
        Min      1Q  Median      3Q     Max 
    -3.4039 -0.6793 -0.0534  0.6325  4.5392 
    
    Random effects:
     Groups   Name                 Variance  Std.Dev. Corr 
     PoS      (Intercept)          2.725e-05 0.005220      
              logindegree_unw_R123 6.574e-06 0.002564 -0.60
     length   (Intercept)          4.197e-04 0.020488      
     Residual                      2.206e-03 0.046964      
    Number of obs: 4586, groups:  PoS, 6; length, 4
    
    Fixed effects:
                          Estimate Std. Error t value
    (Intercept)           0.421954   0.013264  31.811
    logtextwf            -0.020951   0.001366 -15.340
    logdiawf              0.001850   0.005399   0.343
    logcd                -0.025364   0.006109  -4.152
    logindegree_unw_R123 -0.034080   0.002459 -13.858
    
    Correlation of Fixed Effects:
                (Intr) lgtxtw logdwf logcd 
    logtextwf   -0.524                     
    logdiawf     0.062 -0.056              
    logcd       -0.017 -0.070 -0.972       
    lgndg__R123 -0.076 -0.183 -0.007 -0.047

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

    refitting model(s) with ML (instead of REML)
    refitting model(s) with ML (instead of REML)
    refitting model(s) with ML (instead of REML)
    refitting model(s) with ML (instead of REML)

<manuscript-NSD-template.tex>

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

                  main.effect LRT.Chisq LRT.Pr
    1 dialogue.word.frequency     0.145  0.703
    2       context.diversity    17.055  0.000
    3     text.word.frequency   227.798  0.000
    4           SWOW.indegree    18.484  0.000


<a id="org55111ca"></a>

# naming

    IN <- readRDS(file = "/home/lbing/experiments/SWOWCN/ws-lme-IN-naming.rds")
    table(sapply(IN$words, nchar))
    summary (IN)

    
      1 
    679
        words           PoS         logzRT         logtextwf       logdiawf_C       logcd_C      logindegree_unw_R1 logindegree_unw_R123 first_swowR1_max behind_swowR1_max
     Length:679         0:313   Min.   :0.0000   Min.   :6.199   Min.   :1.982   Min.   :1.881   Min.   :0.3010     Min.   :0.301        Min.   :0.301    Min.   :0.6021   
     Class :character   1:162   1st Qu.:0.3220   1st Qu.:7.071   1st Qu.:3.341   1st Qu.:3.067   1st Qu.:0.7782     1st Qu.:1.146        1st Qu.:1.204    1st Qu.:1.4150   
     Mode  :character   2:161   Median :0.4155   Median :7.405   Median :3.821   Median :3.410   Median :1.0792     Median :1.415        Median :1.544    Median :1.6812   
                        3: 35   Mean   :0.4140   Mean   :7.467   Mean   :3.822   Mean   :3.329   Mean   :1.1419     Mean   :1.487        Mean   :1.541    Mean   :1.7020   
                        4:  6   3rd Qu.:0.5013   3rd Qu.:7.803   3rd Qu.:4.275   3rd Qu.:3.676   3rd Qu.:1.4150     3rd Qu.:1.778        3rd Qu.:1.875    3rd Qu.:1.9978   
                        5:  2   Max.   :0.8708   Max.   :9.799   Max.   :6.069   Max.   :3.795   Max.   :2.7505     Max.   :3.038        Max.   :2.751    Max.   :2.7505   
     all_swowR1_max   first_swowR123_max behind_swowR123_max all_swowR123_max
     Min.   :0.4771   Min.   :0.301      Min.   :0.6021      Min.   :0.9031  
     1st Qu.:1.5682   1st Qu.:1.176      1st Qu.:1.5966      1st Qu.:1.8129  
     Median :1.8388   Median :1.431      Median :1.9494      Median :2.1004  
     Mean   :1.8532   Mean   :1.448      Mean   :1.9317      Mean   :2.1002  
     3rd Qu.:2.1303   3rd Qu.:1.699      3rd Qu.:2.2683      3rd Qu.:2.3820  
     Max.   :3.0009   Max.   :2.620      Max.   :3.0378      Max.   :3.0378

    round(cor (IN[, c ("first_swowR1_max", "behind_swowR1_max","all_swowR1_max", "logindegree_unw_R1",
      "first_swowR123_max", "behind_swowR123_max", "all_swowR123_max", "logindegree_unw_R123")]), digit = 3)

                         first_swowR1_max behind_swowR1_max all_swowR1_max logindegree_unw_R1 first_swowR123_max behind_swowR123_max all_swowR123_max logindegree_unw_R123
    first_swowR1_max                1.000             0.811          0.349              0.580              0.339               0.980            0.795                0.540
    behind_swowR1_max               0.811             1.000          0.690              0.468              0.689               0.789            0.979                0.434
    all_swowR1_max                  0.349             0.690          1.000              0.258              0.974               0.337            0.702                0.240
    logindegree_unw_R1              0.580             0.468          0.258              1.000              0.248               0.551            0.443                0.967
    first_swowR123_max              0.339             0.689          0.974              0.248              1.000               0.321            0.678                0.226
    behind_swowR123_max             0.980             0.789          0.337              0.551              0.321               1.000            0.795                0.530
    all_swowR123_max                0.795             0.979          0.702              0.443              0.678               0.795            1.000                0.419
    logindegree_unw_R123            0.540             0.434          0.240              0.967              0.226               0.530            0.419                1.000

Even the simplest LME won't work (singular)

    library (lme4)
    
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

    boundary (singular) fit: see help('isSingular')
    Linear mixed model fit by REML ['lmerMod']
    Formula: logzRT ~ (1 | PoS) + logtextwf + logdiawf_C + logcd_C
       Data: IN
    
    REML criterion at convergence: -869.9
    
    Scaled residuals: 
        Min      1Q  Median      3Q     Max 
    -2.9475 -0.6788 -0.0256  0.6179  3.2453 
    
    Random effects:
     Groups   Name        Variance Std.Dev.
     PoS      (Intercept) 0.00000  0.0000  
     Residual             0.01568  0.1252  
    Number of obs: 679, groups:  PoS, 6
    
    Fixed effects:
                Estimate Std. Error t value
    (Intercept)  1.02879    0.08661  11.879
    logtextwf   -0.05124    0.01301  -3.939
    logdiawf_C  -0.01027    0.02386  -0.431
    logcd_C     -0.05797    0.03396  -1.707
    
    Correlation of Fixed Effects:
               (Intr) lgtxtw lgdw_C
    logtextwf  -0.840              
    logdiawf_C  0.697 -0.527       
    logcd_C    -0.605  0.209 -0.888
    optimizer (nloptwrap) convergence code: 0 (OK)
    boundary (singular) fit: see help('isSingular')
    Analysis of Variance Table
               npar Sum Sq Mean Sq  F value
    logtextwf     1 1.7477  1.7477 111.4612
    logdiawf_C    1 0.2812  0.2812  17.9336
    logcd_C       1 0.0457  0.0457   2.9144

    M <- lm (
      logzRT ~
        logtextwf +
        logdiawf_C +
        logcd_C,
      data = IN
    )
    summary (M)
    anova (M)

    
    Call:
    lm(formula = logzRT ~ logtextwf + logdiawf_C + logcd_C, data = IN)
    
    Residuals:
         Min       1Q   Median       3Q      Max 
    -0.36909 -0.08500 -0.00321  0.07738  0.40638 
    
    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  1.02879    0.08661  11.879  < 2e-16 ***
    logtextwf   -0.05124    0.01301  -3.939 9.02e-05 ***
    logdiawf_C  -0.01027    0.02386  -0.431   0.6669    
    logcd_C     -0.05797    0.03396  -1.707   0.0882 .  
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    
    Residual standard error: 0.1252 on 675 degrees of freedom
    Multiple R-squared:  0.1639,	Adjusted R-squared:  0.1602 
    F-statistic:  44.1 on 3 and 675 DF,  p-value: < 2.2e-16
    Analysis of Variance Table
    
    Response: logzRT
                Df  Sum Sq Mean Sq  F value    Pr(>F)    
    logtextwf    1  1.7477 1.74773 111.4612 < 2.2e-16 ***
    logdiawf_C   1  0.2812 0.28120  17.9336 2.605e-05 ***
    logcd_C      1  0.0457 0.04570   2.9144   0.08825 .  
    Residuals  675 10.5841 0.01568                       
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

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

<manuscript-NSD-template.tex>

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

                  main.effect Fstatistic    Pr delta.r2
    1     text.word.frequency     15.518 0.000    0.018
    2 dialogue.word.frequency      0.185 0.667   -0.001
    3       context.diversity      2.914 0.088    0.002

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

      main.effect Fstatistic    Pr delta.r2
    1   SWOWR1.p1      7.561 0.006    0.008
    2   SWOWR1.p2      7.846 0.005    0.008
    3   SWOWR1.pn      0.361 0.548   -0.001
    4      SWOWR1     12.952 0.000    0.015
    5 SWOWR123.p1      0.306 0.580   -0.001
    6 SWOWR123.p2      6.831 0.009    0.007
    7 SWOWR123.pn      6.539 0.011    0.007
    8    SWOWR123     13.549 0.000    0.015


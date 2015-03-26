# Dispatching S3 Methods for Quick Data Plots 
Nick Salkowski  
Thursday, March 26, 2015  

## Class Systems

R is an object oriented language -- one with different
systems of classes!

S3 is just one of those class systems.

 - Some sloppiness is allowed in S3
     - So, it is fairly easy to learn to use (or abuse)
 - S3 is used for a lot of common R functions



## S3 Example


```r
X_fact <- factor(
  LETTERS[sample.int(5, size = 50, replace = TRUE)])
X_num <- rnorm(50, mean = 10, sd = sqrt(10))
summary(X_fact)
```

```
##  A  B  C  D  E 
##  7 16  8 11  8
```

```r
summary(X_num)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    3.03    8.43   10.10   10.10   12.10   16.80
```

## How does that work?

The `summary` function has different methods, depending on the class of object it is given.


```r
summary
```

```
## function (object, ...) 
## UseMethod("summary")
## <bytecode: 0x00000000088f9428>
## <environment: namespace:base>
```

## Methods


```r
methods(summary)
```

```
##  [1] summary.aov             summary.aovlist*       
##  [3] summary.aspell*         summary.connection     
##  [5] summary.data.frame      summary.Date           
##  [7] summary.default         summary.ecdf*          
##  [9] summary.factor          summary.ggplot*        
## [11] summary.glm             summary.infl*          
## [13] summary.lm              summary.loess*         
## [15] summary.loglm*          summary.manova         
## [17] summary.matrix          summary.mlm*           
## [19] summary.negbin*         summary.nls*           
## [21] summary.packageStatus*  summary.PDF_Dictionary*
## [23] summary.PDF_Stream*     summary.polr*          
## [25] summary.POSIXct         summary.POSIXlt        
## [27] summary.ppr*            summary.prcomp*        
## [29] summary.princomp*       summary.proc_time      
## [31] summary.rlm*            summary.srcfile        
## [33] summary.srcref          summary.stepfun        
## [35] summary.stl*            summary.table          
## [37] summary.tukeysmooth*   
## 
##    Non-visible functions are asterisked
```

## S3 Method Function


```r
summary.factor
```

```
## function (object, maxsum = 100, ...) 
## {
##     nas <- is.na(object)
##     ll <- levels(object)
##     if (any(nas)) 
##         maxsum <- maxsum - 1
##     tbl <- table(object)
##     tt <- c(tbl)
##     names(tt) <- dimnames(tbl)[[1L]]
##     if (length(ll) > maxsum) {
##         drop <- maxsum:length(ll)
##         o <- sort.list(tt, decreasing = TRUE)
##         tt <- c(tt[o[-drop]], `(Other)` = sum(tt[o[drop]]))
##     }
##     if (any(nas)) 
##         c(tt, `NA's` = sum(nas))
##     else tt
## }
## <bytecode: 0x0000000008e2fa38>
## <environment: namespace:base>
```

## Plot is another example


```r
methods(plot)
```

```
##  [1] plot.acf*            plot.correspondence* plot.data.frame*    
##  [4] plot.decomposed.ts*  plot.default         plot.dendrogram*    
##  [7] plot.density*        plot.ecdf            plot.factor*        
## [10] plot.formula*        plot.function        plot.ggplot*        
## [13] plot.gtable*         plot.hclust*         plot.histogram*     
## [16] plot.HoltWinters*    plot.isoreg*         plot.lda*           
## [19] plot.lm*             plot.mca*            plot.medpolish*     
## [22] plot.mlm*            plot.pith*           plot.ppr*           
## [25] plot.prcomp*         plot.princomp*       plot.profile*       
## [28] plot.profile.nls*    plot.ridgelm*        plot.spec*          
## [31] plot.stepfun         plot.stl*            plot.table*         
## [34] plot.ts              plot.tskernel*       plot.TukeyHSD*      
## 
##    Non-visible functions are asterisked
```

## Here are some more examples


```r
methods(coef)
```

```
## [1] coef.aov*      coef.Arima*    coef.default*  coef.fitdistr*
## [5] coef.lda*      coef.listof*   coef.loglm*    coef.nls*     
## [9] coef.ridgelm* 
## 
##    Non-visible functions are asterisked
```

```r
methods(hist)
```

```
## [1] hist.Date*   hist.default hist.POSIXt*
## 
##    Non-visible functions are asterisked
```

## Creating Your Own Class

Recall, S3 is sort of sloppy.  You can just create an object and then tell R which class (or classes) it belongs to!

```r
X_fish <- structure(rpois(50, lambda = 5),
  class = c("fish", "integer"))
summary.fish <- function(object, ...) {
  fish <- object
  table(fish)
  }
summary(X_fish)
```

```
## fish
##  1  2  3  4  5  6  7  8  9 10 11 13 
##  1  5  4 11  7 10  6  1  1  1  2  1
```

## Motivation

Sometimes it is nice to have a plot that summarizes 
your data.

 - Exploring
 - Debugging

There are lots of nice plotting functions, but they 
don't all work with all kinds of data.


```r
X1 <- c(rnorm(70), rep(c(-Inf, Inf), 10),
        rep(c(NaN, NA), 5))
X2 <- factor(c(
  LETTERS[sample.int(5, size = 70, replace = TRUE)],
  rep(NA, 30)))
```

## Histograms? (Part 1)


```r
hist(X1)
```

![plot of chunk unnamed-chunk-10](S3_Presentation_files/figure-html/unnamed-chunk-10.png) 

## Histograms? (Part 2)


```r
(try(hist(X2)))
```

```
## [1] "Error in hist.default(X2) : 'x' must be numeric\n"
## attr(,"class")
## [1] "try-error"
## attr(,"condition")
## <simpleError in hist.default(X2): 'x' must be numeric>
```

## Frequency Plots? (Part 1)


```r
barplot(table(X2))
```

![plot of chunk unnamed-chunk-12](S3_Presentation_files/figure-html/unnamed-chunk-12.png) 

## Frequency Plots? (Part 2)


```r
barplot(table(X1))
```

![plot of chunk unnamed-chunk-13](S3_Presentation_files/figure-html/unnamed-chunk-13.png) 

## ggplot2? (Part 1)


```r
qplot(X1, binwidth = 0.5)
```

![plot of chunk unnamed-chunk-14](S3_Presentation_files/figure-html/unnamed-chunk-14.png) 

## ggplot2? (Part 2)


```r
qplot(X2)
```

![plot of chunk unnamed-chunk-15](S3_Presentation_files/figure-html/unnamed-chunk-15.png) 

## Drawbacks

 - `hist` only handles numbers and dates
 - `barplot` + `table` doesn't handle doubles well
 - No support for lists or data.frames
 - Non-Finite and Missing Values are often dropped
 
## So, I wrote a package . . .

 - I'm relatively new to writing packages 
 (So, it's a little rough around the edges)
 - It's available on GitHub
 - It's called **pithr**
 
## What is a *pith*?

 - One definition of *pith* is *the essence of something*.
 - When used as a verb, *pith* means *to remove the pith from*.  

In the context of the pithr package, a *pith* is a simple summary plot of the data contained in an object.  

That is, the *pith* of your data is the *essence* of your data.

## Installing the pithr package

pithr is not available on CRAN, but it is available on GitHub.  To install 
pithr directly from GitHub, first install the [devtools](https://github.com/hadley/devtools) package, then use `devtools::install_github`.

```
install.packages("devtools")
devtools::install_github("NickSalkowski/pithr")
```

## Using pithr

The most basic command in the pithr package is `pith`.  

`pith` handles a wide variety of data types and structures, producing frequency plots or histograms, depending on the data itself.

## Integers (Range <= 25)

```r
X_int <- rpois(n = 100, lambda = 5)
pith(X_int)
```

![plot of chunk unnamed-chunk-16](S3_Presentation_files/figure-html/unnamed-chunk-16.png) 

## Integers (Range > 25)

```r
X_int2 <- rpois(n = 100, lambda = 500)
pith(X_int2)
```

![plot of chunk unnamed-chunk-17](S3_Presentation_files/figure-html/unnamed-chunk-17.png) 

## Doubles

```r
X_num <- rnorm(n = 100, mean = 5, sd = sqrt(5))
pith(X_num)
```

![plot of chunk unnamed-chunk-18](S3_Presentation_files/figure-html/unnamed-chunk-18.png) 

## Characters

```r
X_char <- LETTERS[X_int]
pith(X_char)
```

![plot of chunk unnamed-chunk-19](S3_Presentation_files/figure-html/unnamed-chunk-19.png) 

## Factors

```r
X_fact <- factor(X_char)
pith(X_fact)
```

![plot of chunk unnamed-chunk-20](S3_Presentation_files/figure-html/unnamed-chunk-20.png) 

## Logicals

```r
X_log <- as.logical(rbinom(100, 1, 0.625))
pith(X_log)
```

![plot of chunk unnamed-chunk-21](S3_Presentation_files/figure-html/unnamed-chunk-21.png) 

## Dates

```r
X_Date <- as.Date(sample.int(10000, size = 100, replace = TRUE), 
  origin = "1970-01-01")
pith(X_Date)
```

![plot of chunk unnamed-chunk-22](S3_Presentation_files/figure-html/unnamed-chunk-22.png) 

## Matrices & Arrays
Matrices and arrays are collapsed into vectors by `pith`.  

```r
X_mat <- matrix(rpois(400, 100),  ncol = 20)
pith(X_mat)
```

![plot of chunk unnamed-chunk-23](S3_Presentation_files/figure-html/unnamed-chunk-23.png) 

## Lists and data.frames
If `pith` is given a list or data.frame, each element or column is summarized separately.


```r
par(mfrow = c(1,2))
pith(cars)
```

![plot of chunk unnamed-chunk-24](S3_Presentation_files/figure-html/unnamed-chunk-24.png) 

## NA Values

`pith` seperates NA values, and presents their frequencies separately


```r
pith(X2)
```

![plot of chunk unnamed-chunk-25](S3_Presentation_files/figure-html/unnamed-chunk-25.png) 

## Non-Finite Values

`pith` separates non-finite values, and presents their frequencies separately.

```r
pith(X1)
```

![plot of chunk unnamed-chunk-26](S3_Presentation_files/figure-html/unnamed-chunk-26.png) 

## Arguments

`pith` accepts several arguments that help control the plot.

- plot If TRUE, a plot is produced.
- xname The "name" of the data.  This is used to produce the main plot title.
- breaks, include.lowest, right These arguments are passed to the `hist` 
  function, if a histogram is produced.
- ... Additional plot arguments.

## Example with arguments


```r
pith(X1, xname = "Numeric Vector Example", breaks = 5, las = 1)
```

![plot of chunk unnamed-chunk-27](S3_Presentation_files/figure-html/unnamed-chunk-27.png) 

## pithy Returns

`pith` invisibly returns a pith class object, which is a list that contains summary statistics for the data.  

There are some situations where it would 
be useful to return the data object inself, instead. 

`pithy` is a convenience 
function that calls `pith`, but returns the object.

This behavior is particularly handy when used with the 
[magrittr](https://github.com/smbache/magrittr) and 
[dplyr](https://github.com/hadley/dplyr) packages.

## pithy Example

```r
X_unif <- pithy(runif(100))
```

![plot of chunk unnamed-chunk-28](S3_Presentation_files/figure-html/unnamed-chunk-28.png) 

## magrittr + pithy


```r
X_gamma <- rgamma(100, 2, 2) %>%
  pithy
```

![plot of chunk unnamed-chunk-29](S3_Presentation_files/figure-html/unnamed-chunk-29.png) 

## dplyr + pithy

```r
par(mfrow = c(1, 2))
iris %>% select(Sepal.Length) %>% pithy %>%
  transmute(SLsq = Sepal.Length ^ 2) %>% pith
```

![plot of chunk unnamed-chunk-30](S3_Presentation_files/figure-html/unnamed-chunk-30.png) 

## Special dplyr + pithy functions
pithr also contains helper functions `filter_pithy`, `select_pithy`, 
`mutate_pithy`, and `transmute_pithy` that filter, select, mutate, and 
transmute data sets before calling `pithy`.  

Just like `pithy`, they 
return the original data set (before any filtering, selecting, or mutating).

## select_pithy example

```r
par(mfrow = c(1, 2))
iris %>% select_pithy(Petal.Length) %>%
  transmute_pithy(SLsq = Sepal.Length ^ 2) %>% tbl_df
```

![plot of chunk unnamed-chunk-31](S3_Presentation_files/figure-html/unnamed-chunk-31.png) 

```
## Source: local data frame [150 x 5]
## 
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1           5.1         3.5          1.4         0.2  setosa
## 2           4.9         3.0          1.4         0.2  setosa
## 3           4.7         3.2          1.3         0.2  setosa
## 4           4.6         3.1          1.5         0.2  setosa
## 5           5.0         3.6          1.4         0.2  setosa
## 6           5.4         3.9          1.7         0.4  setosa
## 7           4.6         3.4          1.4         0.3  setosa
## 8           5.0         3.4          1.5         0.2  setosa
## 9           4.4         2.9          1.4         0.2  setosa
## 10          4.9         3.1          1.5         0.1  setosa
## ..          ...         ...          ...         ...     ...
```

## Effort vs. Quality

I tend to think about plotting applications as either **artisinal** or **industrial**

 - **artisinal plots** are created by a skilled plotmaker for a specific purpose.  Quality is highly valued.
 - **industrial plots** usually aren't quite as good, but can be mass produced with much less effort per plot.
 
`pithr` is built to produce *useful* plots with minimal effort, so I consider definitely it industrial.

If you want to produce a small number of beautiful artisinal plots, you are almost certainly better off using `ggplot2`.

## Live Demo


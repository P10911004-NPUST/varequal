# O'Brien's Test of Homogeneity of Variances

Performs O'Brien's test to assess the null hypothesis that the variances
are equal across all groups (samples) defined by the independent
variable.

## Usage

``` r
O.Brien_test(
  data,
  formula,
  alpha = 0.05,
  silent = FALSE,
  summary = FALSE,
  misc = FALSE,
  transform = function(x) (x - stats::median(x))^2
)
```

## Arguments

- data:

  A data frame containing the variables specified in the formula.

- formula:

  A formula of the form `DV ~ IV`, where `DV` is the dependent
  (response) variable and `IV` is the independent (grouping) variable.

- alpha:

  A numeric value specifying the significance level. Must be between 0
  and 1. Default is 0.05.

- silent:

  A logical value. If `FALSE` (default), results are printed to the
  console. If `TRUE`, no output is printed.

- summary:

  A logical value (default: `FALSE`). If `TRUE`, a summary table for the
  input data is returned.

- misc:

  A logical value. If `FALSE` (default), only essential parameters are
  returned. If `TRUE`, additional auxiliary parameters are included in
  the output.

- transform:

  A function used to transform the response variable into deviations
  from a specified location measure.

## Value

A list containing the test statistics, p-value, degrees of freedom, and
optionally a summary table and/or auxiliary parameters, depending on the
values of `summary` and `misc`.

## Details

`transform`: The concept is similar to ANOVA procedure (transform the
response variable to residuals before analysis). Possible transformation
are:

- y' = \|yi - ybar\|

- y' = (yi - ybar) ^ 2 (default)

- y' = ln((yi - ybar) ^ 2)

- y' = sqrt(\|yi - ybar\|)

The `ybar` could be either mean, median (default), or trimmed-mean.

*Note:* This test is often regarded as conservative and may have
relatively low power to detect heteroscedasticity. The Levene and
Brown-Forsythe tests are generally preferred for assessing the
homogeneity of variances.

## References

O’Brien, R. G. (1981). A simple test for variance effects in
experimental designs. Psychological Bulletin, 89(3), 570–574.
https://doi.org/10.1037/0033-2909.89.3.570

## See also

\[Brown_Forsythe_test\]\[Levene_test\]\[O.Neill_Mathews_test\]

## Examples

``` r
df0 <- CYCB1[[1]]
out <- O.Brien_test(df0, cells ~ grp)
#> 
#> ---------------------------------------
#> O'Brien's homogeneity of variance test
#> 
#> Response: cells
#> 
#>           DF        SS       MS Fvalue  pvalue
#> Group      3  46503.18 15501.06 3.7508 0.01576
#> Residuals 57 235564.27  4132.71               
#> Total     60 282067.44                        
#> 
#> #> Group variances are unequal.
#> ---------------------------------------
boxplot(cells ~ grp, df0, horizontal = TRUE)
points(x = df0$cells, y = jitter(as.numeric(df0$grp), amount = 0.15))
```

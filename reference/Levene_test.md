# Levene's Test of Homogeneity of Variances

Performs Levene's test to assess the null hypothesis that the variances
are equal across all groups (samples) defined by the independent
variable.

## Usage

``` r
Levene_test(
  data,
  formula,
  alpha = 0.05,
  silent = FALSE,
  summary = FALSE,
  misc = FALSE,
  transform = function(x) abs(x - stats::median(x))
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

- y' = \|yi - ybar\| (default)

- y' = (yi - ybar) ^ 2

- y' = ln((yi - ybar) ^ 2)

- y' = sqrt(\|yi - ybar\|)

The `ybar` could be either mean, median (default), or trimmed-mean.

## References

Levene, H. (1960). Robust tests for equality of variances. In I. Olkin
(Ed.), Contributions to probability and statistics: Essays in honor of
Harold Hotelling (pp. 278–292). Stanford University Press.

Sharma, D., & Kibria, B. M. G. (2013). On some test statistics for
testing homogeneity of variances: A comparative study. Journal of
Statistical Computation and Simulation, 83, 1944–1963.
https://doi.org/10.1080/00949655.2012.675336

Zhou, Y., Zhu, Y., & Wong, W. K. (2023). Statistical tests for
homogeneity of variance for clinical trials and recommendations.
Contemporary Clinical Trials Communications, 33, 101119.
https://doi.org/10.1016/j.conctc.2023.101119

## See also

[Brown_Forsythe_test](https://p10911004-npust.github.io/varequal/reference/Brown_Forsythe_test.md)

## Examples

``` r
df0 <- roGFP[[1]]
out <- Levene_test(df0, ro ~ grp)
#> 
#> ---------------------------------------
#> Levene's homogeneity of variance test
#> 
#> Response: ro
#> 
#>           DF   SS MS Fvalue pvalue
#> Group      3 0.01  0 3.1837 0.0325
#> Residuals 46 0.03  0              
#> Total     49 0.03                 
#> 
#> #> Group variances are unequal.
#> ---------------------------------------
boxplot(ro ~ grp, df0, horizontal = TRUE)
points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
```

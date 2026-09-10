# Brown-Forsythe Test of Homogeneity of Variances

Performs Brown-Forsythe test to assess the null hypothesis that the
variances are equal across all groups (samples) defined by the
independent variable.

## Usage

``` r
Brown_Forsythe_test(
  data,
  formula,
  alpha = 0.05,
  silent = FALSE,
  summary = FALSE,
  misc = FALSE,
  transform = function(x) abs(x - stats::median(x)),
  method = c("MBF", "BF")
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

- method:

  A character specifying either `"MBF"` (default) or `"BF"`.

## Value

A list containing the test statistics, p-value, degrees of freedom, and
optionally a summary table and/or auxiliary parameters, depending on the
values of `summary` and `misc`.

## Details

`transform` The concept is similar to ANOVA procedure (transform the
response variable to residuals before analysis). Possible transformation
are:

- y' = \|yi - ybar\| (default)

- y' = (yi - ybar) ^ 2

- y' = ln((yi - ybar) ^ 2)

- y' = sqrt(\|yi - ybar\|)

The `ybar` could be either mean, median (default), or trimmed-mean.

`method`

- `"BF"`: The original Brown–Forsythe test proposed by Brown and
  Forsythe (1974), a modification of Levene's test that uses the median
  instead of the mean.

- `"MBF"` The modified Brown–Forsythe test proposed by Mehrotra (1997),
  which adjusts the degrees of freedom and consequently yields an
  approximate F-distribution of F(f1, f2) rather than F(k - 1, N - k).
  Compared with the original version (`BF`), this modification tends to
  reduce the Type I error rate at the cost of a higher Type II error
  rate.

## References

Brown, M. B., & Forsythe, A. B. (1974). Robust tests for the equality of
variances. Journal of the American Statistical Association, 69(346),
364–367. https://doi.org/10.1080/01621459.1974.10482955

Mehrotra, D. V. (1997). Improving the Brown–Forsythe solution to the
generalized Behrens–Fisher problem. Communications in
Statistics—Simulation and Computation, 26, 1139–1145.
https://doi.org/10.1080/03610919708813431

## See also

[Levene_test](https://p10911004-npust.github.io/varequal/reference/Levene_test.md)

## Examples

``` r
df0 <- roGFP[[1]]
out <- Brown_Forsythe_test(df0, ro ~ grp)
#> 
#> --------------------------------------------
#> Brown-Forsythe homogeneity of variance test
#> 
#> Response: ro
#> 
#>              DF   SS   MS Fvalue  pvalue
#> Group      1.96 0.01 0.01 3.9769 0.02918
#> Residuals 32.86 0.05    0               
#> Total     34.81 0.06                    
#> 
#> #> Group variances are unequal.
#> --------------------------------------------
boxplot(ro ~ grp, df0, horizontal = TRUE)
points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
```

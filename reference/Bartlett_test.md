# Bartlett's Test of Homogeneity of Variances

Performs Bartlett's test to assess the null hypothesis that variances
are equal across all groups (samples) defined by the independent
variable. This test assumes that the data within each group are normally
distributed and is sensitive to departures from normality.

## Usage

``` r
Bartlett_test(
  data,
  formula,
  alpha = 0.05,
  silent = FALSE,
  summary = FALSE,
  misc = FALSE
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

## Value

A list containing the test statistics, p-value, degrees of freedom, and
optionally a summary table and/or auxiliary parameters, depending on the
values of `summary` and `misc`.

## References

Bartlett, M. S. (1937). Properties of sufficiency and statistical tests.
Proceedings of the Royal Society of London. Series A, Mathematical and
Physical Sciences, 160(901), 268–282.
https://doi.org/10.1098/rspa.1937.0109

Montgomery, D. C. (2017). Experiments with a single factor: The analysis
of variance. In Design and analysis of experiments (9th ed., pp. 82–83).
John Wiley & Sons. ISBN: 9781119299363

## See also

[stats::bartlett.test](https://rdrr.io/r/stats/bartlett.test.html)

## Examples

``` r
df0 <- roGFP[[1]]
out <- Bartlett_test(df0, ro ~ grp)
#> 
#> ----------------------------------------
#>  Bartlett's homogeneity of variance test
#> 
#>  Response: y
#> 
#>  Chi-Square: 18.4724
#>  p-value: 0.00035
#> 
#>  #> Group variances are unequal. 
#> ----------------------------------------
#> 
boxplot(ro ~ grp, df0, horizontal = TRUE)
points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
```

# Homogeneity of variance test

A wrapper function for the homoscedasticity tests available in this
package.

## Usage

``` r
check_var_equal(
  data,
  formula,
  alpha = 0.05,
  silent = FALSE,
  summary = FALSE,
  method = "LV",
  ...
)
```

## Arguments

- data:

  A data frame or a list of numeric vectors.

- formula:

  Formula (default: NULL). If `data` is a data frame, define the val ~
  group.

- alpha:

  Significance threshold, range from 0 to 1 (default: 0.05).

- silent:

  A logical value. If `FALSE` (default), results are printed to the
  console. If `TRUE`, no output is printed.

- summary:

  A logical value (default: `FALSE`). If `TRUE`, a summary table for the
  input data is returned.

- method:

  Character (default: "LV"). Abbreviation specifying the normality test
  to perform. Available options are
  `c("AB", "BL", "FK", "LG", "LV", "MBF", "OB", "OM")`.

- ...:

  Additional arguments passed to the selected test function.

## Value

A list.

## Details

The `method` argument specifies the statistical procedure used to assess
whether group variances are equal.

Available methods are:

- `"AB"`: Ansari-Bradley test A rank-based nonparametric test for
  homogeneity of scale (dispersion) across groups. It is often used as
  an alternative to the F-test when data are non-normal. However, the
  Fligner–Killeen test is generally more robust and is recommended for
  this purpose.

- `"BL"`: Bartlett test A classical parametric test for assessing
  homoscedasticity across multiple groups. It is highly sensitive to
  outliers and deviations from normality. When the data are normally
  distributed and free of outliers, it is the most robust and powerful
  tests for equality of variances.

- `"FK"`: Fligner–Killeen test A rank-based nonparametric test for
  homogeneity of variances across groups. It is based on absolute
  deviations from the median and is highly robust to non-normality and
  outliers.

- `"LG"`: 't Lam's G test An extension of Cochran's C test used to
  evaluate the internal consistency of variances. Although primarily
  designed as a variance outlier detection method rather than a formal
  test of homoscedasticity (such as Levene's or Bartlett's test), it can
  be used informally to assess variance homogeneity across groups. Its
  robustness is particularly strong under normality and in the absence
  of outliers.

- `"LV"`: Levene's test A classical test for equality of variances based
  on an ANOVA framework. This implementation uses the median as the
  center (instead of the mean), making it more robust to non-normality
  and outliers.

- `"MBF"`: Brown–Forsythe test (modified by Mehrotra) A robust
  modification of Levene's test proposed by Brown and Forsythe. The
  degrees of freedom are further adjusted following Mehrotra's
  correction, improving performance under non-normality and in the
  presence of outliers.

- `"OB"`: O'Brien test A variance homogeneity test similar in spirit to
  Levene's test, based on transformed observations designed to reduce
  sensitivity to non-normality.

- `"OM"`: O'Neill–Mathews test A modified Levene-type procedure that
  uses a weighted least squares approach.

In all methods, the null hypothesis is that group variances are equal.

## Examples

``` r
check_var_equal(roGFP[[1]], ro ~ grp, method = "LV")
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
```

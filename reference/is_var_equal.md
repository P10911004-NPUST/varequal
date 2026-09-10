# Homogeneity of variance test

A convenient wrapper that returns a logical value indicating whether
variances across groups are equal. It makes its decision based on the
results of several homoscedasticity tests, including the modified
Brown–Forsythe (MBF), Fligner–Killeen (FK), 't Lam's G (LG), Levene's
(LV), and O'Neill–Mathews (OM) tests.

## Usage

``` r
is_var_equal(
  data,
  formula = NULL,
  alpha = 0.05,
  silent = TRUE,
  summary = FALSE,
  sensitivity = 3
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

  Logical (default: FALSE). If `TRUE`, show the summary table.

- sensitivity:

  Numeric, range from 1 to 5 (default: 3). The greater the value, the
  greater chance to consider as variance not equal.

## Value

A boolean value or a list if the `summary` is set to `TRUE`.

## Examples

``` r
is_var_equal(roGFP[[1]], ro ~ grp)
#> [1] FALSE
```

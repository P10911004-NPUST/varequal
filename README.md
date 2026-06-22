# varequal

<!-- badges: start -->
[![Repo_Status_Badge](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://cran.r-project.org/package=varequal)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/varequal?color=brightgreen)](https://cran.r-project.org/package=varequal)
[![R-CMD-check](https://github.com/P10911004-NPUST/varequal/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/P10911004-NPUST/varequal/actions/workflows/R-CMD-check.yaml)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/varequal)](https://cranlogs.r-pkg.org/badges/varequal)
[![Downloads](https://cranlogs.r-pkg.org/badges/varequal?color=blue)](https://cranlogs.r-pkg.org/badges/varequal)
<!-- [![License: MIT](https://img.shields.io/badge/License-MIT-maroon.svg)](https://opensource.org/licenses/MIT) -->
<!-- badges: end -->

An R package for testing whether group variances are equal.

# Installation

You can install the package from [CRAN](https://cran.r-project.org/package=varequal) with:

``` r
install.packages("varequal")
```

or the developmental version from [GitHub](https://github.com/P10911004-NPUST/varequal) with:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("P10911004-NPUST/varequal")
```

# Quick start
```r

```


# TODO

- [x] Ansari-Bradley test
  - [Ansari & Bradley, 1960](http://www.jstor.org/stable/2237814)
- [ ] Moses test
  - [Moses, 1963](https://projecteuclid.org/journals/annals-of-mathematical-statistics/volume-34/issue-3/Rank-Tests-of-Dispersion/10.1214/aoms/1177704020.full)
- [ ] Miller test
  - [Miller, 1968](https://www.jstor.org/stable/2239049)
- [x] Bartlett's test
- [x] Brown-Forsythe test
- [ ] Cochran C test
- [ ] Cochran G test
  - [Lam, 2010](https://doi.org/10.1016/j.aca.2009.11.032)
- [ ] Fligner-Killeen test
  - [Fligner & Killeen, 1974](https://www.tandfonline.com/doi/abs/10.1080/01621459.1976.10481517)
- [ ] Hartley's test
  - [Frey, 2010](https://doi.org/10.1002/cjs.10069)
- [x] Levene's test


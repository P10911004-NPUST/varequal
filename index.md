# varequal

An R package for testing whether group variances are equal.

There are also other nice alternatives such as
[`vartest`](https://cran.r-project.org/package=vartest) and other
friends.

# Installation

You can install the package from
[CRAN](https://cran.r-project.org/package=varequal) with:

``` r

install.packages("varequal")
```

or the development version from
[GitHub](https://github.com/P10911004-NPUST/varequal) with:

``` r

if (!require("pak")) install.packages("pak")
pak::pak("P10911004-NPUST/varequal")
```

# Quick start

``` r

is_var_equal(roGFP[[1]], ro ~ grp)
```

  

# TODO

Ansari-Bradley test

- [Ansari & Bradley, 1960](http://www.jstor.org/stable/2237814)

Moses test

- [Moses,
  1963](https://projecteuclid.org/journals/annals-of-mathematical-statistics/volume-34/issue-3/Rank-Tests-of-Dispersion/10.1214/aoms/1177704020.full)

Miller test

- [Miller, 1968](https://www.jstor.org/stable/2239049)

Bartlett’s test

Brown-Forsythe test

Cochran G test

- [Lam, 2010](https://doi.org/10.1016/j.aca.2009.11.032)

Fligner-Killeen test

- [Fligner & Killeen,
  1974](https://www.tandfonline.com/doi/abs/10.1080/01621459.1976.10481517)

Hartley’s test

- [Frey, 2010](https://doi.org/10.1002/cjs.10069)

Levene’s test

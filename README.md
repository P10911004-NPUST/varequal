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

or the development version from [GitHub](https://github.com/P10911004-NPUST/varequal) with:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("P10911004-NPUST/varequal")
```

# Quick start
```r
is_var_equal(roGFP[[1]], ro ~ grp)
```

<br>

# Benchmark

> **O_O**: observe is homo, predict as homo  
> **O_X**: observe is homo, predict as hetero  
> **X_X**: observe is hetero, predict as hetero  
> **X_O**: observe is hetero, predict as homo  
> **Type 1 error**: `O_X / (O_O + O_X)` &times; 100%  
> **Type 2 error**: `X_O / (X_X + X_O)` &times; 100%  
> **Accuracy**: `(O_O + X_X) / (O_O + O_X + X_X + X_O)` &times; 100%


## For normally-distributed, moderate sample size (8 &le; n &le; 20), and outliers-free data
|                              |  O_O  |  O_X  |  X_X  |  X_O  | Type 1 error (%) | Type 2 error (%) | Accuracy (%) |
| :----------                  | :---: | :---: | :---: | :---: |       :---:      |       :---:      |     :---:    | 
| Ansari-Bradley test          |  974  |   26  |  749  |  251  |        2.6       |        25.1      |     86.15    |
| Bartlett's test              |  939  |   61  |  985  |   15  |        6.1       |         1.5      |     96.20    |
| Mehrotra-Brown-Forsythe test |  977  |   23  |  767  |  233  |        2.3       |        23.3      |     87.20    |
| Brown-Forsythe test          |  973  |   27  |  823  |  177  |        2.7       |        17.7      |     89.80    |
| Fligner-Killeen test         |  976  |   24  |  824  |  176  |        2.4       |        17.6      |     90.00    |
| 't Lam's G test              |  919  |   81  |  982  |   18  |        8.1       |         1.8      |     95.05    |
| Levene's test                |  973  |   27  |  864  |  136  |        2.7       |        13.6      |     91.85    |
| O'Brien test                 |  983  |   17  |  625  |  375  |        1.7       |        37.5      |     80.40    |
| O'Neill-Mathews test         |  983  |   17  |  820  |  180  |        1.7       |        18.0      |     90.15    |
|||||||||


## For normally-distributed, small sample size (3 &le; n &le; 7), and outliers-free data.
|                              |  O_O  |  O_X  |  X_X  |  X_O  | Type 1 error (%) | Type 2 error (%) | Accuracy (%) |
| :----------                  | :---: | :---: | :---: | :---: |       :---:      |       :---:      |     :---:    | 
| Ansari_Bradley_test          |  967  |   33  |  104  |  896  |        3.3       |       89.6       |     53.55    |
| Bartlett_test                |  957  |   43  |  440  |  560  |        4.3       |       56.0       |     69.85    |
| Brown_Forsythe_test          |  991  |    9  |   61  |  939  |        0.9       |       93.9       |     52.60    |
| BF                           |  986  |   14  |   75  |  925  |        1.4       |       92.5       |     53.05    |
| Fligner_Killeen_test         |  978  |   22  |   97  |  903  |        2.2       |       90.3       |     53.75    |
| Lam_G_test                   |  840  |  160  |  607  |  393  |       16.0       |       39.3       |     72.35    |
| Levene_test                  |  973  |   27  |  121  |  879  |        2.7       |       87.9       |     54.70    |
| O.Brien_test                 |  996  |    4  |   30  |  970  |        0.4       |       97.0       |     51.30    |
| O.Neill_Mathews_test         |  994  |    6  |   58  |  942  |        0.6       |       94.2       |     52.60    |
|||||||||


## For normally-distributed and moderate sample size (8 &le; n &le; 20) data, with one or two outliers.
|                              |  O_O  |  O_X  |  X_X  |  X_O  | Type 1 error (%) | Type 2 error (%) | Accuracy (%) |
| :----------                  | :---: | :---: | :---: | :---: |       :---:      |       :---:      |     :---:    |
| Ansari_Bradley_test          |  972  |   28  |  843  |  157  |        2.8       |       15.7       |     90.75    |
| Bartlett_test                |    0  | 1000  | 1000  |    0  |      100.0       |        0.0       |     50.00    |
| Brown_Forsythe_test          | 1000  |    0  |  590  |  410  |        0.0       |       41.0       |     79.50    |
| BF                           | 1000  |    0  |  745  |  255  |        0.0       |       25.5       |     87.25    |
| Fligner_Killeen_test         |  974  |   26  |  910  |   90  |        2.6       |        9.0       |     94.20    |
| Lam_G_test                   |    0  | 1000  | 1000  |    0  |      100.0       |        0.0       |     50.00    |
| Levene_test                  | 1000  |    0  |  790  |  210  |        0.0       |       21.0       |     89.50    |
| O.Brien_test                 | 1000  |    0  |  101  |  899  |        0.0       |       89.9       |     55.05    |
| O.Neill_Mathews_test         | 1000  |    0  |  713  |  287  |        0.0       |       28.7       |     85.65    |
|||||||||


<br>

# TODO

- [x] Ansari-Bradley test
  - [Ansari & Bradley, 1960](http://www.jstor.org/stable/2237814)
- [ ] Moses test
  - [Moses, 1963](https://projecteuclid.org/journals/annals-of-mathematical-statistics/volume-34/issue-3/Rank-Tests-of-Dispersion/10.1214/aoms/1177704020.full)
- [ ] Miller test
  - [Miller, 1968](https://www.jstor.org/stable/2239049)
- [x] Bartlett's test
- [x] Brown-Forsythe test
- [x] Cochran G test
  - [Lam, 2010](https://doi.org/10.1016/j.aca.2009.11.032)
- [x] Fligner-Killeen test
  - [Fligner & Killeen, 1974](https://www.tandfonline.com/doi/abs/10.1080/01621459.1976.10481517)
- [ ] Hartley's test
  - [Frey, 2010](https://doi.org/10.1002/cjs.10069)
- [x] Levene's test


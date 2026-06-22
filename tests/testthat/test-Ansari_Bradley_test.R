test_that("Ansari_Bradley_test", {
    plasma_etching <- data.frame(
        etch_rate = c(575, 542, 530, 539, 570,
                      565, 593, 590, 579, 610,
                      600, 651, 610, 637, 629,
                      725, 700, 715, 685, 710),
        power = as.character(rep(c(160, 180, 200, 220), each = 5))
    )

    out <- Ansari_Bradley_test(plasma_etching, etch_rate ~ power, silent = TRUE, misc = TRUE)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 4)
    pval <- round(out[["pvalue"]], 5)

    testthat::expect_equal(K2, 0.7363)
    testthat::expect_equal(pval, 0.86464)
})

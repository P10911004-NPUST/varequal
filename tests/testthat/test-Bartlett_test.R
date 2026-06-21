test_that("Bartlett_test", {
    plasma_etching <- data.frame(
        etch_rate = c(575, 542, 530, 539, 570,
                      565, 593, 590, 579, 610,
                      600, 651, 610, 637, 629,
                      725, 700, 715, 685, 710),
        power = rep(c(160, 180, 200, 220), each = 5)
    )

    out <- Bartlett_test(plasma_etching, etch_rate ~ power, misc = TRUE)
    q <- round(out[["misc"]][["q"]], 2)
    c_ <- round(out[["misc"]][["c"]], 2)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 2)
    testthat::expect_equal(q, 0.21)
    testthat::expect_equal(c_, 1.10)
    testthat::expect_equal(K2, 0.43)
})

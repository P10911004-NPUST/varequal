test_that("Ansari_Bradley_test", {
    df0 <- roGFP[[1]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, ro_index ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 6.085513)
    testthat::expect_equal(pval, 0.1075232)

    df0 <- roGFP[[2]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, ro_index ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 2.679904)
    testthat::expect_equal(pval, 0.4436532)

    df0 <- roGFP[[3]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, ro_index ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 8.711946)
    testthat::expect_equal(pval, 0.0333763)

    df0 <- CYCB1[[1]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, cell_num ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 8.351839)
    testthat::expect_equal(pval, 0.0392733)

    df0 <- CYCB1[[2]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, cell_num ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 3.913087)
    testthat::expect_equal(pval, 0.2710034)

    df0 <- CYCB1[[3]]
    df0[["grp"]] <- with(df0, paste(TEMP, RGF1, sep = "_"))
    out <- Ansari_Bradley_test(df0, cell_num ~ grp)
    K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(K2, 6.493696)
    testthat::expect_equal(pval, 0.0899115)
})

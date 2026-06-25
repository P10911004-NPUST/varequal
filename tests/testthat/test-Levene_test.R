test_that("Levene_test", {
    df0 <- roGFP[[1]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Levene_test(df0, ro_index ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 3.183717)
    testthat::expect_equal(pval, 0.0325032)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- roGFP[[2]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Levene_test(df0, ro_index ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 1.518332)
    testthat::expect_equal(pval, 0.216684)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- roGFP[[3]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Levene_test(df0, ro_index ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 3.47185)
    testthat::expect_equal(pval, 0.0232738)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- CYCB1[[1]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Levene_test(df0, cell_num ~ grp, transform = function(x) abs(x - mean(x)))
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 6.327024)
    testthat::expect_equal(pval, 0.0008857)
    # boxplot(cell_num ~ grp, df0, horizontal = TRUE)
    # points(df0$cell_num, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- CYCB1[[2]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Levene_test(df0, cell_num ~ grp, transform = function(x) (x - mean(x, trim = 0.1)) ^ 2)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 2.855829)
    testthat::expect_equal(pval, 0.0442163)
    # boxplot(cell_num ~ grp, df0, horizontal = TRUE)
    # points(df0$cell_num, jitter(as.numeric(df0$grp), amount = 0.15))
})

test_that("Brown_Forsythe_test", {
    df0 <- roGFP[[1]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, ro_index ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 3.976918)
    testthat::expect_equal(pval, 0.02918)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- roGFP[[2]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, ro_index ~ grp, method = "BF")
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 1.619042)
    testthat::expect_equal(pval, 0.1932621)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- roGFP[[3]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, ro_index ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 3.632587)
    testthat::expect_equal(pval, 0.0321278)
    # boxplot(ro_index ~ grp, df0, horizontal = TRUE)
    # points(df0$ro_index, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- CYCB1[[1]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, cell_num ~ grp)
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 3.970365)
    testthat::expect_equal(pval, 0.0251204)
    # boxplot(cell_num ~ grp, df0, horizontal = TRUE)
    # points(df0$cell_num, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- CYCB1[[2]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, cell_num ~ grp, method = "BF")
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 2.494966)
    testthat::expect_equal(pval, 0.0724296)
    # boxplot(cell_num ~ grp, df0, horizontal = TRUE)
    # points(df0$cell_num, jitter(as.numeric(df0$grp), amount = 0.15))

    df0 <- CYCB1[[3]]
    df0[["grp"]] <- as.factor(with(df0, paste(TEMP, RGF1, sep = "_")))
    out <- Brown_Forsythe_test(df0, cell_num ~ grp, method = "BF")
    Fval <- round(out[["statistic"]][["F"]], 6)
    pval <- round(out[["pvalue"]], 7)
    testthat::expect_equal(Fval, 2.229808)
    testthat::expect_equal(pval, 0.0968327)
    # boxplot(cell_num ~ grp, df0, horizontal = TRUE)
    # points(df0$cell_num, jitter(as.numeric(df0$grp), amount = 0.15))
})



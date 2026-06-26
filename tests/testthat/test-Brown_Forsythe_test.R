test_that("Brown_Forsythe_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(3.976918, 1.619042, 3.632587)
    answer_pval <- c(0.02918, 0.1986409, 0.0321278)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- Brown_Forsythe_test(df0, ro ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["F"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(ro ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$ro, jitter(as.numeric(df0$grp), amount = 0.15))
    }


    #--------------------------------------------------------------------------#
    #                        Test on dataset: CYCB1                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(3.970365, 2.494966, 2.229808)
    answer_pval <- c(0.0155278, 0.0724296, 0.0968327)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- Brown_Forsythe_test(df0, cells ~ grp, silent = TRUE, method = "BF")
        Fval <- round(out[["statistic"]][["F"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})



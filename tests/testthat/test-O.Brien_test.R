test_that("O.Brien_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(2.421972, 1.775599, 2.555942)
    answer_pval <- c(0.0779335, 0.1590772, 0.0664665)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- O.Brien_test(df0, ro ~ grp, silent = TRUE)
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
    answer_Fval <- c(3.750825, 2.419551, 1.728527)
    answer_pval <- c(0.0157606, 0.0745338, 0.1707386)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- O.Brien_test(df0, cells ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["F"]], 6)
        pval <- round(out[["pvalue"]], 7)

        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

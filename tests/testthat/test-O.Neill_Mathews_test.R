test_that("O.Neill_Mathews_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(2.86192, 1.40931, 3.174867)
    answer_pval <- c(0.0469376, 0.2467174, 0.0326156)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- O.Neill_Mathews_test(df0, ro ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # print(sprintf("F = %s;  p = %s", Fval, pval))
        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(ro ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$ro, jitter(as.numeric(df0$grp), amount = 0.15))
    }

    #--------------------------------------------------------------------------#
    #                        Test on dataset: CYCB1                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(3.866595, 2.268643, 2.184389)
    answer_pval <- c(0.0137829, 0.0893113, 0.0991699)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- O.Neill_Mathews_test(df0, cells ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
        pval <- round(out[["pvalue"]], 7)

        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # print(sprintf("F = %s;  p = %s", Fval, pval))
        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

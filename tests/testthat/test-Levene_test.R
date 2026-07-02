test_that("Levene_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(3.183717, 1.518332, 3.47185)
    answer_pval <- c(0.0325032, 0.216684, 0.0232738)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- Levene_test(df0, ro ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
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
    answer_Fval <- c(4.096162, 2.416869, 2.296763)
    answer_pval <- c(0.0105778, 0.0747738, 0.0867113)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- Levene_test(df0, cells ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
        pval <- round(out[["pvalue"]], 7)

        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

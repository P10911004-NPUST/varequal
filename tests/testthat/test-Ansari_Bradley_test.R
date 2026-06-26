test_that("Ansari_Bradley_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_K2 <- c(6.085513, 2.679904, 8.711946)
    answer_pval <- c(0.1075232, 0.4436532, 0.0333763)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- Ansari_Bradley_test(df0, ro ~ grp, silent = TRUE)
        K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(K2, answer_K2[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("Chi = %s;  p = %s", K2, pval)
        # boxplot(ro ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$ro, jitter(as.numeric(df0$grp), amount = 0.15))
    }

    #--------------------------------------------------------------------------#
    #                        Test on dataset: CYCB1                            #
    #--------------------------------------------------------------------------#
    answer_K2 <- c(8.351839, 3.913087, 6.493696)
    answer_pval <- c(0.0392733, 0.2710034, 0.0899115)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- Ansari_Bradley_test(df0, cells ~ grp, silent = TRUE)
        K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(K2, answer_K2[i])
        testthat::expect_equal(pval, answer_pval[i])

        # title <- sprintf("Chi = %s;  p = %s", K2, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

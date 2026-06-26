test_that("Fligner_Killeen_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        fk <- stats::fligner.test(ro ~ grp, df0)
        out <- Fligner_Killeen_test(df0, ro ~ grp, silent = TRUE)
        K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(K2, round(unname(fk$statistic), 6))
        testthat::expect_equal(pval, round(fk$p.value, 7))

        # title <- sprintf("Chi = %s;  p = %s", K2, pval)
        # boxplot(ro ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$ro, jitter(as.numeric(df0$grp), amount = 0.15))
    }


    #--------------------------------------------------------------------------#
    #                        Test on dataset: CYCB1                            #
    #--------------------------------------------------------------------------#
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        fk <- stats::fligner.test(cells ~ grp, df0)
        out <- Fligner_Killeen_test(df0, cells ~ grp, silent = TRUE)
        K2 <- round(out[["statistic"]][["ChiSquare"]], 6)
        pval <- round(out[["pvalue"]], 7)
        testthat::expect_equal(K2, round(unname(fk$statistic), 6))
        testthat::expect_equal(pval, round(fk$p.value, 7))

        # title <- sprintf("Chi = %s;  p = %s", K2, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

test_that("Lam_G_test", {
    #--------------------------------------------------------------------------#
    #                        Test on dataset: roGFP                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(8.351380, 2.459031, 7.338714)
    answer_pval <- c(0.0000133, 0.0155387, 0.0000167)
    for (i in 1:3)
    {
        df0 <- roGFP[[i]]
        out <- Lam_G_test(df0, ro ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
        pval <- round(out[["pvalue"]], 7)

        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # print(sprintf("F: %.6f; p: %.7f", Fval, pval))
        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(ro ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$ro, jitter(as.numeric(df0$grp), amount = 0.15))
    }

    #--------------------------------------------------------------------------#
    #                        Test on dataset: CYCB1                            #
    #--------------------------------------------------------------------------#
    answer_Fval <- c(4.850096, 4.051600, 2.040497)
    answer_pval <- c(0.0000883, 0.0003920, 0.1411406)
    for (i in 1:3)
    {
        df0 <- CYCB1[[i]]
        out <- Lam_G_test(df0, cells ~ grp, silent = TRUE)
        Fval <- round(out[["statistic"]][["Fvalue"]], 6)
        pval <- round(out[["pvalue"]], 7)

        testthat::expect_equal(Fval, answer_Fval[i])
        testthat::expect_equal(pval, answer_pval[i])

        # print(sprintf("F: %.6f; p: %.7f", Fval, pval))
        # title <- sprintf("F = %s;  p = %s", Fval, pval)
        # boxplot(cells ~ grp, df0, horizontal = TRUE, main = title)
        # points(df0$cells, jitter(as.numeric(df0$grp), amount = 0.15))
    }
})

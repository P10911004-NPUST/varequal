#' Homogeneity of variance test
#'
#' A convenient wrapper that returns a logical value indicating whether variances
#' across groups are equal. It makes its decision based on the results of several
#' homoscedasticity tests, including the modified Brown–Forsythe (MBF), Fligner–Killeen (FK),
#' 't Lam's G (LG), Levene's (LV), and O'Neill–Mathews (OM) tests.
#'
#' @param data A data frame or a list of numeric vectors.
#' @param formula Formula (default: NULL).
#'        If `data` is a data frame, define the val ~ group.
#' @param alpha Significance threshold, range from 0 to 1 (default: 0.05).
#' @param sensitivity Numeric, range from 1 to 5 (default: 3).
#'        The greater the value, the greater chance to consider as variance not equal.
#' @param summary Logical (default: FALSE). If `TRUE`, show the summary table.
#'
#' @returns A boolean value or a list if the `summary` is set to `TRUE`.
#' @examples
#' is_var_equal(roGFP[[1]], ro ~ grp)
#' @export
is_var_equal <- function(
        data,
        formula = NULL,
        alpha = 0.05,
        sensitivity = 3,
        summary = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)

    BF <- Brown_Forsythe_test(data, formula, alpha, silent = TRUE, misc = TRUE)
    FK <- Fligner_Killeen_test(data, formula, alpha, silent = TRUE, misc = TRUE)
    LG <- Lam_G_test(data, formula, alpha, silent = TRUE, misc = TRUE)
    LV <- Levene_test(data, formula, alpha, silent = TRUE, misc = TRUE)
    OM <- O.Neill_Mathews_test(data, formula, alpha, silent = TRUE, misc = TRUE)

    is_var_equal <- unlist(
        lapply(list(BF, FK, LG, LV, OM),
               function(x) x[["is_var_equal"]]),
        use.names = FALSE
    )

    ret <- (sum(is_var_equal) >= sensitivity)

    if (isTRUE(summary))
    {
        test_names <- unlist(
            lapply(list(BF, FK, LG, LV, OM),
                   function(x)
                   {
                       stat_symbol <- names(x[["statistic"]])
                       nm <- x[["method"]]
                       nm <- gsub(" homogeneity of variance test", "", nm)
                       nm <- sprintf("%s (%s)", nm, stat_symbol)
                       return(nm)
                   }),
            use.names = FALSE
        )

        statistic <- unlist(
            lapply(list(BF, FK, LG, LV, OM),
                   function(x) unname(x[["statistic"]])),
            use.names = FALSE
        )

        crit_val <- unlist(
            lapply(list(BF, FK, LG, LV, OM),
                   function(x)
                   {
                       misc <- x[["misc"]]
                       crit <- misc[[grep("*_crit", names(misc))]]
                       return(crit)
                   }),
            use.names = FALSE
        )

        pval <- unlist(
            lapply(list(BF, FK, LG, LV, OM),
                   function(x) unname(x[["pvalue"]])),
            use.names = FALSE
        )

        tab <- data.frame(
            check.names = FALSE,
            row.names = test_names,
            "is_var_equal" = is_var_equal,
            pval = pval,
            statistic = statistic,
            critical_value = crit_val
        )

        ret <- list("is_var_equal" = ret,
                    "summary" = tab)
    }

    return(ret)
}

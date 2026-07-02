#' Bartlett's Test of Homogeneity of Variances
#'
#' Performs Bartlett's test to assess the null hypothesis that variances
#' are equal across all groups (samples) defined by the independent variable.
#' This test assumes that the data within each group are normally distributed
#' and is sensitive to departures from normality.
#'
#' @param data A data frame containing the variables specified in the formula.
#' @param formula A formula of the form `DV ~ IV`, where `DV` is the dependent
#'        (response) variable and `IV` is the independent (grouping) variable.
#' @param alpha A numeric value specifying the significance level. Must be
#'        between 0 and 1. Default is 0.05.
#' @param silent A logical value. If `FALSE` (default), results are
#'        printed to the console. If `TRUE`, no output is printed.
#' @param summary A logical value (default: `FALSE`). If `TRUE`, a summary table
#'        for the input data is returned.
#' @param misc A logical value. If `FALSE` (default), only essential
#'        parameters are returned. If `TRUE`, additional auxiliary
#'        parameters are included in the output.
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @examples
#' df0 <- roGFP[[1]]
#' out <- Bartlett_test(df0, ro ~ grp)
#' boxplot(ro ~ grp, df0, horizontal = TRUE)
#' points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' Bartlett, M. S. (1937). Properties of sufficiency and statistical tests.
#' Proceedings of the Royal Society of London.
#' Series A, Mathematical and Physical Sciences, 160(901), 268–282.
#' https://doi.org/10.1098/rspa.1937.0109
#'
#' Montgomery, D. C. (2017).
#' Experiments with a single factor: The analysis of variance.
#' In Design and analysis of experiments (9th ed., pp. 82–83). John Wiley & Sons.
#' ISBN: 9781119299363
#' @seealso [stats::bartlett.test]
#' @export
Bartlett_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = FALSE,
        misc = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)
    x_name <- colnames(df0)[2]
    y_name <- colnames(df0)[1]
    x <- df0[["x"]]
    y <- df0[["y"]]

    k <- length(unique(x)) # number of groups
    ni <- tapply(y, x, length) # sample size of each groups
    N <- sum(ni) # total sample size
    Si2 <- tapply(y, x, stats::var) # variance of each groups
    Sp2 <- sum((ni - 1) * Si2) / (N - k)
    q <- (N - k) * log(Sp2, 10) - sum((ni - 1) * log(Si2, 10))
    c_ <- 1 + (1 / (3 * (k - 1))) * (sum(1 / (ni - 1)) - (1 / (N - k)))
    K2 <- 2.3026 * q / c_
    pval <- stats::pchisq(K2, k - 1, lower.tail = FALSE)
    K2_crit <- stats::qchisq(alpha, k - 1, lower.tail = FALSE)

    ret <- varequal_standard_output(
        method = "Bartlett's homogeneity of variance test",
        is_var_equal = (pval > alpha),
        alpha = alpha,
        alternative = "two.sided",
        statistic = c("ChiSquare" = K2),
        pvalue = pval
    )

    if (isTRUE(summary))
    {
        tab <- with(
            data = df0,
            expr = vapply(
                X = c("length", "mean", "median", "min", "max", "sd"),
                FUN = function(fns) tapply(y, x, fns),
                FUN.VALUE = numeric(length(unique(x)))
            )
        )
        colnames(tab) <- c("N", "AVG", "MED", "MIN", "MAX", "SD")
        ret[["summary"]] <- tab
    }

    if (isTRUE(misc))
    {
        ret[["misc"]] <- list(
            "SD_pooled" = Sp2,
            "DF" = k - 1,
            "ChiSquare" = K2,
            "ChiSquare_crit" = K2_crit,
            "q" = q,
            "c" = c_
        )
    }

    if (isFALSE(silent))
    {
        cat("\n----------------------------------------\n",
            "Bartlett's homogeneity of variance test\n\n",
            sprintf("Response: %s\n\n", y_name),
            sprintf("Chi-Square: %s\n", round(K2, 4)),
            sprintf("p-value: %s\n\n", round(pval, 5)),
            sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")),
            "\n----------------------------------------\n\n")
    }

    invisible(ret)
}

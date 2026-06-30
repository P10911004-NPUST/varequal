#' Fligner-Killeen Test of Homogeneity of Variances
#'
#' Performs Fligner-Killeen test to assess the null hypothesis that the variances
#' are equal across all groups (samples) defined by the independent variable.
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
#' df0 <- CYCB1[[1]]
#' out <- Fligner_Killeen_test(df0, cells ~ grp)
#' boxplot(cells ~ grp, df0, horizontal = TRUE)
#' points(x = df0$cells, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' Fligner, M. A., & Killeen, T. J. (1976).
#' Distribution-free two-sample tests for scale.
#' Journal of the American Statistical Association, 71(353), 210–213.
#' https://doi.org/10.1080/01621459.1976.10481517
#'
#' Conover, W. J., Johnson, M. E., & Johnson, M. M. (1981).
#' A comparative study of tests for homogeneity of variances, with applications
#' to the outer continental shelf bidding data.
#' Technometrics, 23, 351–361.
#' https://doi.org/10.1080/00401706.1981.10487680
#' @seealso [stats::fligner.test][Ansari_Bradley_test]
#' @export
Fligner_Killeen_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = FALSE,
        misc = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)
    x_name <- attr(df0, "x_name")
    y_name <- attr(df0, "y_name")
    x <- df0[["x"]]
    y <- df0[["y"]]

    k <- length(unique(x))  # number of groups
    N <- length(y)  # total sample size

    z <- tapply(y, x, function(j) j - stats::median(j))
    df0[["y'"]] <- unlist(z)
    df0[["rank"]] <- rank(abs(df0[["y'"]]))

    # Ranking from two sides to center
    # Formula in Table 4 (Score function of "F-K") in Conover et al. (1981)
    df0[["a(N,i)"]] <- stats::qnorm(0.5 + df0[["rank"]] / (2 * (N + 1)))

    ni <- c(tapply(df0[["y"]], df0[["x"]], length))
    Ai_bar <- c(tapply(df0[["a(N,i)"]], df0[["x"]], mean))
    a_bar <- sum(df0[["a(N,i)"]]) / N
    V2 <- sum((df0[["a(N,i)"]] - a_bar) ^ 2) / (N - 1)

    K2 <- sum(ni * ((Ai_bar - a_bar) ^ 2) / V2)
    pval <- stats::pchisq(K2, k - 1, lower.tail = FALSE)
    K2_crit <- stats::qchisq(alpha, k - 1, lower.tail = FALSE)

    ret <- varequal_standard_output(
        method = "Fligner-Killeen homogeneity of variance test",
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
            "DF" = k - 1,
            "ChiSquare" = K2,
            "ChiSquare_crit" = K2_crit,
            "Ai_bar" = Ai_bar,
            "a_bar" = a_bar,
            "V2" = V2,
            "data" = df0
        )
    }

    if (isFALSE(silent))
    {
        cat("\n---------------------------------------------\n",
            "Fligner-Killeen homogeneity of variance test\n\n",
            sprintf("Response: %s\n\n", y_name),
            sprintf("Chi-Square: %s\n", round(K2, 4)),
            sprintf("Chi-Square critical: %s\n", round(K2_crit, 4)),
            sprintf("p-value: %s\n\n", round(pval, 5)),
            sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")),
            "\n---------------------------------------------\n\n")
    }

    invisible(ret)
}

#' Ansari-Bradley Test of Homogeneity of Variances
#'
#' Performs Ansari-Bradley test to assess the null hypothesis that the variances
#' are equal across all groups (samples) defined by the independent variable.
#'
#' @param data A data frame containing the variables specified in the formula.
#' @param formula A formula of the form `DV ~ IV`, where `DV` is the dependent
#'        (response) variable and `IV` is the independent (grouping) variable.
#' @param alpha A numeric value specifying the significance level. Must be
#'        between 0 and 1. Default is 0.05.
#' @param silent A logical value. If `FALSE` (default), results are
#'        printed to the console. If `TRUE`, no output is printed.
#' @param summary A logical value. If `TRUE` (default), a summary table
#'        of the test results is returned.
#' @param misc A logical value. If `FALSE` (default), only essential
#'        parameters are returned. If `TRUE`, additional auxiliary
#'        parameters are included in the output.
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @details
#' This function is based on Conover et al. (1981) and uses an approximate chi-square
#' test. Results may be inaccurate for small total sample sizes (N < 20) or when
#' there are many tied values.
#'
#' @examples
#' plasma_etching <- data.frame(
#'     etch_rate = c(575, 542, 530, 539, 570,
#'                   565, 593, 590, 579, 610,
#'                   600, 651, 610, 637, 629,
#'                   725, 700, 715, 685, 710),
#'     power = as.character(rep(c(160, 180, 200, 220), each = 5))
#' )
#' Ansari_Bradley_test(plasma_etching, etch_rate ~ power)
#' @references
#' Ansari, A. R., & Bradley, R. A. (1960).
#' Rank-sum tests for dispersions.
#' The Annals of Mathematical Statistics, 31, 1174–1189.
#'
#' Conover, W. J., Johnson, M. E., & Johnson, M. M. (1981).
#' A comparative study of tests for homogeneity of variances, with applications
#' to the outer continental shelf bidding data.
#' Technometrics, 23, 351–361.
#' https://doi.org/10.1080/00401706.1981.10487680
#' @seealso [stats::ansari.test]
#' @export
Ansari_Bradley_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)
    x_name <- attr(df0, "x_name")
    y_name <- attr(df0, "y_name")

    N <- length(df0[["y"]])
    k <- length(unique(df0[["x"]]))

    z <- tapply(df0[["y"]], df0[["x"]], function(xi) xi - stats::median(xi))
    df0[["Z(1..N)"]] <- unlist(z)
    df0[["rank"]] <- rank(df0[["Z(1..N)"]])
    df0 <- df0[order(df0[["rank"]]), ]

    # Formula in Table 4 (Score function of "F-A-B")
    df0[["a(N,i)"]] <- (N + 1) / 2 - abs(df0[["rank"]] - ((N + 1) / 2))

    ni <- c(tapply(df0[["y"]], df0[["x"]], length))
    Ai_bar <- c(tapply(df0[["a(N,i)"]], df0[["x"]], mean))
    a_bar <- sum(df0[["a(N,i)"]]) / N
    V2 <- sum((df0[["a(N,i)"]] - a_bar) ^ 2) / (N - 1)

    K2 <- sum(ni * ((Ai_bar - a_bar) ^ 2) / V2)
    pval <- stats::pchisq(K2, k - 1, lower.tail = FALSE)
    K2_crit <- stats::qchisq(alpha, k - 1, lower.tail = FALSE)

    ret <- varequal_standard_output(
        method = "Ansari-Bradley homogeneity of variance test",
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
            "ChiSq" = K2,
            "ChiSq_crit" = K2_crit,
            "Ai_bar" = Ai_bar,
            "a_bar" = a_bar,
            "V2" = V2,
            "data" = df0
        )
    }

    if (isFALSE(silent))
    {
        cat("\n---------------------------------------------\n",
            "Ansari-Bradley homogeneity of variance test\n\n",
            sprintf("Response: %s\n\n", y_name),
            sprintf("Chi-Square: %s\n", round(K2, 4)),
            sprintf("p-value: %s\n\n", round(pval, 5)),
            sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")),
            "\n---------------------------------------------\n\n")
    }

    invisible(ret)
}

#
# .ansari_bradley_test <- function(x, y, alpha = 0.05, alternative = "two.sided")
# {
#     k <- 2 # number of groups
#     m <- length(x)
#     n <- length(y)
#     N <- m + n
#     x <- stats::setNames(x - stats::median(x), rep("x", m))
#     y <- stats::setNames(y - stats::median(y), rep("y", n))
#
#     z <- sort(append(x, y, after = m))
#     z_order <- seq_along(z)
#     z_order_median <- (N + 1) / 2
#     # Start enumerating from two side to the center,
#     # so will become something like {1, 2, 3, 3, 2, 1}.
#     # This is the a(N,i) score function in Conover et al. (1981).
#     z_order_ranked <- z_order_median - abs(z_order_median - z_order)
#
#     ni <- c(tapply(z_order_ranked, names(z), length))
#     Ai_bar <- c(tapply(z_order_ranked, names(z), mean))
#     a_bar <- sum(z_order_ranked) / N
#     V2 <- sum((z_order_ranked - a_bar) ^ 2) / (N - 1)
#
#     K2 <- sum(ni * ((Ai_bar - a_bar) ^ 2) / V2)
#     pval <- stats::pchisq(K2, k - 1, lower.tail = FALSE)
#     K2_crit <- stats::qchisq(alpha, k - 1, lower.tail = FALSE)
# }

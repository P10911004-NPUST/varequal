#' 't Lam's G Test of Homogeneity of Variances
#'
#' Performs Lam's G test, an extension of Cochran's C test, to evaluate the
#' internal consistency of variances. Although it is primarily a variance
#' outlier test rather than a "true" homoscedasticity test such as Levene's
#' test or Bartlett's test, it can still be used conceptually to assess the
#' homogeneity of variances across groups.
#'
#' @param data A data frame containing the variables specified in the formula.
#' @param formula A formula of the form `DV ~ IV`, where `DV` is the dependent
#'        (response) variable and `IV` is the independent (grouping) variable.
#' @param alpha A numeric value specifying the significance level. Must be
#'        between 0 and 1. Default is 0.05.
#' @param alternative Character (default: "two.sided"). Specifies the alternative
#'        hypothesis. Available options are c("two.sided", "less", "greater").
#' @param silent A logical value. If `FALSE` (default), results are
#'        printed to the console. If `TRUE`, no output is printed.
#' @param summary A logical value (default: `FALSE`). If `TRUE`, a summary table
#'        for the input data is returned.
#' @param misc A logical value. If `FALSE` (default), only essential
#'        parameters are returned. If `TRUE`, additional auxiliary
#'        parameters are included in the output.
#'
#' @details
#' `Note:`
#' Under normally distributed data and moderate sample sizes (8 < n < 20),
#' Lam's G test performs comparably to Bartlett's test. For small sample sizes
#' (n < 8), it appears to outperform several alternative tests, providing a
#' favorable balance between Type I and Type II error rates. In contrast, some
#' alternative methods achieve lower Type I error rates at the cost of
#' substantially higher Type II error rates. Note that this test is highly
#' sensitive to outliers.
#'
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @examples
#' df0 <- roGFP[[1]]
#' out <- Lam_G_test(df0, ro ~ grp)
#' boxplot(ro ~ grp, df0, horizontal = TRUE)
#' points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' ’T Lam, R. U. E. (2010).
#' Scrutiny of variance results for outliers: Cochran’s test optimized.
#' Analytica Chimica Acta, 659(1–2), 68–84.
#' https://doi.org/10.1016/j.aca.2009.11.032
#' @seealso [Brown_Forsythe_test]
#' @export
Lam_G_test <- function(
        data,
        formula,
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        silent = FALSE,
        summary = FALSE,
        misc = FALSE
) {
    alt <- match.arg(alternative[1], c("two.sided", "less", "greater"))

    df0 <- tidy_to_dataframe(data, formula)
    x_name <- attr(df0, "x_name")
    y_name <- attr(df0, "y_name")
    x <- df0[["x"]]
    y <- df0[["y"]]

    k <- length(unique(x))  # number of groups
    N <- length(y)  # total sample size
    zeta <- if (alt == "two.sided") alpha / (2 * k) else alpha / k

    ni <- tapply(y, x, length)
    grp_vars <- tapply(y, x, stats::var)
    v_pool <- sum(ni - 1) # Equation 2
    var_pool <- sum((ni - 1) * grp_vars) / v_pool

    if (alt == "two.sided")
    {
        out_max <- .g_max(grp_vars, ni, k, v_pool, var_pool)
        out_min <- .g_min(grp_vars, ni, k, v_pool, var_pool)
        p_max <- out_max[["pval"]] * 2
        p_min <- out_min[["pval"]] * 2

        # if the largest variance group is significantly different from the remaining
        if (p_max < zeta)
            out <- out_max

        # if the smallest variance group is significantly different from the remaining
        if (p_min < zeta & p_max > zeta)
            out <- out_min

        # if both directions are not significant
        if (p_max > zeta & p_min > zeta)
            out <- out_max

    } else if (alt == "greater")
        out <- .g_max(grp_vars, ni, k, v_pool, var_pool)
    else if (alt == "less")
        out <- .g_min(grp_vars, ni, k, v_pool, var_pool)

    outlying_id <- out[["id"]]
    v_j <- out[["v_j"]]
    var_j <- out[["var_j"]]
    Gj <- unname(out[["Gj"]])
    Fj <- unname(out[["Fj"]])
    pval <- unname(out[["pval"]])

    Fj_crit <- stats::qf(zeta, v_j, v_pool - v_j, lower.tail = FALSE)
    outlying_group <- if (pval < alpha) names(grp_vars)[outlying_id] else ""

    ret <- varequal_standard_output(
        method = "'t Lam's G homogeneity of variance test",
        is_var_equal = (pval > alpha),
        alpha = alpha,
        alternative = alt,
        statistic = c("Fvalue" = Fj),
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
            "DF_between" = v_j,
            "DF_within" = v_pool - v_j,
            "F_val" = Fj,
            "F_crit" = Fj_crit,
            "outlying_group" = outlying_group,
            "max_var" = var_j,
            "max_G" = Gj,
            "n(max_var)" = v_j + 1,
            "v_pool" = v_pool,
            "var_pool" = var_pool
        )
    }

    if (isFALSE(silent))
    {
        cat("\n---------------------------------------------\n")
        cat(sprintf("%s\n\n", ret[["method"]]))
        cat(sprintf("Response: %s\n\n", y_name))
        cat(sprintf("Outlying group: %s\n\n", outlying_group))
        cat(sprintf("F-value: %s\n", round(Fj, 4)))
        cat(sprintf("F-critical: %s\n", round(Fj_crit, 4)))
        cat(sprintf("p-value: %s\n\n", round(pval, 5)))
        cat(sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")))
        cat("\n---------------------------------------------\n")
    }

    invisible(ret)
}


.g_max <- function(grp_vars, ni, k, v_pool, var_pool)
{
    max_var_id <- which.max(grp_vars)
    v_j <- ni[max_var_id] - 1
    var_j <- grp_vars[max_var_id]
    Gj <- (v_j * var_j) / (v_pool * var_pool) # Equation 12
    Fj <- (v_pool / v_j - 1) / (1 / Gj - 1) # Equation 15
    pval <- stats::pf(Fj, v_j, v_pool - v_j, lower.tail = FALSE) * k
    ret <- list("id" = max_var_id,
                "v_j" = v_j,
                "var_j" = var_j,
                "Gj" = Gj,
                "Fj" = Fj,
                "pval" = pval)
    return(ret)
}


.g_min <- function(grp_vars, ni, k, v_pool, var_pool)
{
    min_var_id <- which.min(grp_vars)
    v_j <- ni[min_var_id] - 1
    var_j <- grp_vars[min_var_id]
    Gj <- (v_j * var_j) / (v_pool * var_pool) # Equation 12
    Fj <- (v_pool / v_j - 1) / (1 / Gj - 1) # Equation 15
    Fj <- 1 / Fj  # F-value must be > 1
    pval <- stats::pf(Fj, v_j, v_pool - v_j, lower.tail = FALSE) * k
    ret <- list("id" = min_var_id,
                "v_j" = v_j,
                "var_j" = var_j,
                "Gj" = Gj,
                "Fj" = Fj,
                "pval" = pval)
    return(ret)
}

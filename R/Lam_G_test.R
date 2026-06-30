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
        out_max <- g_max(grp_vars, ni, k, v_pool, var_pool)
        out_min <- g_min(grp_vars, ni, k, v_pool, var_pool)
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
        out <- g_max(grp_vars, ni, k, v_pool, var_pool)
    else if (alt == "less")
        out <- g_min(grp_vars, ni, k, v_pool, var_pool)

    # The output of the `out` are:
    # list(
    # "max_var_id" = max_var_id,
    # "v_j" = v_j,
    # "var_j" = var_j,
    # "Gj" = Gj,
    # "Fj" = Fj,
    # "pval" = pval)


    outlying_id <- out[["id"]]
    v_j <- out[["v_j"]]
    var_j <- out[["var_j"]]
    Gj <- out[["Gj"]]
    Fj <- out[["Fj"]]
    pval <- out[["pval"]]
    # return(out)

    # outlier_id <- unname(which.max(grp_vars))
    # v_j <- ni[outlier_id] - 1
    # var_j <- grp_vars[outlier_id]
    #
    # Gj <- (v_j * var_j) / (v_pool * var_pool) # Equation 12
    # Fj <- (v_pool / v_j - 1) / (1 / Gj - 1) # Equation 15
    #
    # pval <- stats::pf(Fj, v_j, v_pool - v_j, lower.tail = FALSE) * k
    # if (alt == "two.sided") pval <- pval * 2
    #
    Fj_crit <- stats::qf(zeta, v_j, v_pool - v_j, lower.tail = FALSE)
    outlying_group <- if (pval < alpha) names(grp_vars)[outlying_id] else ""

    ret <- varequal_standard_output(
        method = "Lam's G ratio homogeneity of variance test",
        is_var_equal = (pval > alpha),
        alpha = alpha,
        alternative = alt,
        statistic = c("F" = Fj),
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
        cat("\n------------------------------------------\n")
        cat(sprintf("%s\n\n", ret[["method"]]))
        cat(sprintf("Response: %s\n\n", y_name))
        cat(sprintf("Outlying group: %s\n\n", outlying_group))
        cat(sprintf("F-value: %s\n", round(Fj, 4)))
        cat(sprintf("F-critical: %s\n", round(Fj_crit, 4)))
        cat(sprintf("p-value: %s\n\n", round(pval, 5)))
        cat(sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")))
        cat("\n------------------------------------------\n")
    }

    invisible(ret)
}


g_max <- function(grp_vars, ni, k, v_pool, var_pool)
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


g_min <- function(grp_vars, ni, k, v_pool, var_pool)
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

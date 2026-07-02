#' O'Brien's Test of Homogeneity of Variances
#'
#' Performs O'Brien's test to assess the null hypothesis that the variances
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
#' @param transform A function used to transform the response variable into
#'        deviations from a specified location measure.
#'
#' @details
#' `transform`:
#' The concept is similar to ANOVA procedure (transform the response variable to
#' residuals before analysis). Possible transformation are:
#'
#' - y' = |yi - ybar|
#' - y' = (yi - ybar) ^ 2  (default)
#' - y' = ln((yi - ybar) ^ 2)
#' - y' = sqrt(|yi - ybar|)
#'
#' The `ybar` could be either mean, median (default), or trimmed-mean.
#'
#' *Note:* This test is often regarded as conservative and may have relatively
#' low power to detect heteroscedasticity. The Levene and Brown-Forsythe tests
#' are generally preferred for assessing the homogeneity of variances.
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @examples
#' df0 <- CYCB1[[1]]
#' out <- O.Brien_test(df0, cells ~ grp)
#' boxplot(cells ~ grp, df0, horizontal = TRUE)
#' points(x = df0$cells, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' O’Brien, R. G. (1981).
#' A simple test for variance effects in experimental designs.
#' Psychological Bulletin, 89(3), 570–574.
#' https://doi.org/10.1037/0033-2909.89.3.570
#' @seealso [Brown_Forsythe_test][Levene_test][O.Neill_Mathews_test]
#' @export
O.Brien_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = FALSE,
        misc = FALSE,
        transform = function(x) (x - stats::median(x)) ^ 2
) {
    if (is.character(transform)) transform <- get(transform)
    if (is.function(transform))
    {
        func_ret <- transform(1:3)
        if (length(func_ret) != 3 || !is.numeric(func_ret))
            stop("`func` should return a numeric vector same length with the response variable.")
    } else {
        stop("`func` should be a function.")
    }

    df0 <- tidy_to_dataframe(data, formula)
    x_name <- attr(df0, "x_name")
    y_name <- attr(df0, "y_name")
    x <- df0[["x"]]
    y <- df0[["y"]]

    k <- length(unique(x))  # number of groups
    N <- length(y)  # total sample size

    ni <- tapply(y, x, length)
    is_balance <- (length(unique(ni)) == 1)
    grp_means <- tapply(y, x, mean)
    grp_vars <- tapply(y, x, stats::var)

    y_prime <- tapply(y, x, transform)  # Equal to (y_ijk - yij_bar) ^ 2
    r_ijk <- vector("list", k)
    for (i in seq_along(y_prime))
    {
        n <- ni[i]
        s2 <- grp_vars[i]
        y_ijk <- y_prime[[i]]
        r_ijk[[i]] <- ((n - 1.5) * n * y_ijk - 0.5 * s2 * (n - 1)) / ((n - 1) * (n - 2))
    }

    #--------------------------------------------------------------------------#
    # The r_ijk is the new response variable for ANOVA.
    # So, everything after this is a general ANOVA procedure.
    #--------------------------------------------------------------------------#
    yy <- unlist(r_ijk) # use this as the dependent variable for ANOVA
    grand_mean <- mean(yy)
    grand_sum <- sum(yy)
    grp_sums <- tapply(yy, x, sum)
    grp_means <- tapply(yy, x, mean)

    DF_between <- k - 1
    DF_within <- N - k
    DF_total <- N - 1

    if (isTRUE(is_balance))
    {
        SS_total <- sum((yy - grand_mean) ^ 2)
        SS_between <- mean(ni) * sum((grp_means - grand_mean) ^ 2)
        SS_within <- SS_total - SS_between
    } else {
        SS_total <- sum(yy ^ 2) - (grand_sum ^ 2 / N)
        SS_between <- sum(grp_sums ^ 2 / ni) - (grand_sum ^ 2 / N)
        SS_within <- SS_total - SS_between
    }

    MS_between <- SS_between / DF_between
    MS_within <- SS_within / DF_within

    Fval <- MS_between / MS_within
    Fval_crit <- stats::qf(alpha, DF_between, DF_within, lower.tail = FALSE)
    pval <- stats::pf(Fval, DF_between, DF_within, lower.tail = FALSE)

    aov_tab <- data.frame(
        row.names   = c("Group", "Residuals", "Total"),
        "DF"        = c(DF_between, DF_within, DF_total),
        "SS"        = c(SS_between, SS_within, SS_total),
        "MS"        = c(MS_between, MS_within, NA_real_),
        "Fvalue"    = c(Fval, NA_real_, NA_real_),
        "Fcrit"     = c(Fval_crit, NA_real_, NA_real_),
        "pvalue"    = c(pval, NA_real_, NA_real_),
        "signif"    = c(pval2asterisk(pval, alpha), NA_character_, NA_character_)
    )

    ret <- varequal_standard_output(
        method = "Levene's homogeneity of variance test",
        is_var_equal = (pval > alpha),
        alpha = alpha,
        alternative = "two.sided",
        statistic = c("Fvalue" = Fval),
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
            "F_val" = Fval,
            "F_crit" = Fval_crit,
            "ANOVA" = aov_tab,
            "transform (y')" = df0
        )
    }

    if (isFALSE(silent))
    {
        show_aov <- data.frame(
            row.names = c("Group", "Residuals", "Total"),
            "DF" = as.character(as.integer(aov_tab[["DF"]])),
            "SS" = as.character(round(aov_tab[["SS"]], 2)),
            "MS" = as.character(round(aov_tab[["MS"]], 2)),
            "Fvalue" = as.character(round(aov_tab[["Fvalue"]], 4)),
            "pvalue" = as.character(round(aov_tab[["pvalue"]], 5))
        )

        show_aov[is.na(show_aov)] <- ""

        cat("\n---------------------------------------\n")
        cat("O'Brien's homogeneity of variance test\n\n")
        cat(sprintf("Response: %s\n\n", y_name))
        print(show_aov)
        cat(sprintf("\n#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")))
        cat("\n---------------------------------------\n")
    }

    invisible(ret)
}

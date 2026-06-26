#' Levene's Test of Homogeneity of Variances
#'
#' Performs Levene's test to assess the null hypothesis that the variances
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
#' - y' = |yi - ybar| (default)
#' - y' = (yi - ybar) ^ 2
#' - y' = ln((yi - ybar) ^ 2)
#' - y' = sqrt(|yi - ybar|)
#'
#' The `ybar` could be either mean, median (default), or trimmed-mean.
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @examples
#' df0 <- roGFP[[1]]
#' out <- Levene_test(df0, ro ~ grp)
#' boxplot(ro ~ grp, df0, horizontal = TRUE)
#' points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' Levene, H. (1960).
#' Robust tests for equality of variances. In I. Olkin (Ed.),
#' Contributions to probability and statistics: Essays in honor of Harold Hotelling
#' (pp. 278–292). Stanford University Press.
#'
#' Sharma, D., & Kibria, B. M. G. (2013).
#' On some test statistics for testing homogeneity of variances: A comparative study.
#' Journal of Statistical Computation and Simulation, 83, 1944–1963.
#' https://doi.org/10.1080/00949655.2012.675336
#'
#' Zhou, Y., Zhu, Y., & Wong, W. K. (2023).
#' Statistical tests for homogeneity of variance for clinical trials and recommendations.
#' Contemporary Clinical Trials Communications, 33, 101119.
#' https://doi.org/10.1016/j.conctc.2023.101119
#' @seealso [Brown_Forsythe_test]
#' @export
Levene_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = FALSE,
        misc = FALSE,
        transform = function(x) abs(x - stats::median(x))
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

    y_prime <- tapply(y, x, transform)
    ni <- unlist(lapply(y_prime, length))
    is_balance <- (length(unique(ni)) == 1)

    grp_var <- unlist(lapply(y_prime, stats::var))
    grp_means <- unlist(lapply(y_prime, mean))

    yij <- unlist(y_prime, use.names = FALSE)
    df0[["y'"]] <- yij
    grand_mean <- mean(yij)
    yi <- tapply(yij, x, sum)
    y_total <- sum(yij)

    DF_between <- k - 1
    DF_within <- N - k
    DF_total <- N - 1

    if (isTRUE(is_balance))
    {
        SS_total <- sum((yij - grand_mean) ^ 2)
        SS_between <- mean(ni) * sum((grp_means - grand_mean) ^ 2)
        SS_within <- SS_total - SS_between
    } else {
        SS_total <- sum(yij ^ 2) - (y_total ^ 2 / N)
        SS_between <- sum(yi ^ 2 / ni) - (y_total ^ 2 / N)
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
        statistic = c("F" = Fval),
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

        cat("\n------------------------------------------\n")
        cat("Levene's homogeneity of variance test\n\n")
        cat(sprintf("Response: %s\n\n", y_name))
        print(show_aov)
        cat(sprintf("\n#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")))
        cat("\n------------------------------------------\n")
    }

    invisible(ret)
}



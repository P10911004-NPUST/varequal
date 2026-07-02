#' Brown-Forsythe Test of Homogeneity of Variances
#'
#' Performs Brown-Forsythe test to assess the null hypothesis that the variances
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
#' @param method A character specifying either `"MBF"` (default) or `"BF"`.
#'
#' @details
#' `transform`
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
#' `method`
#' - `"BF"`: The original Brown–Forsythe test proposed by Brown and Forsythe (1974),
#'   a modification of Levene's test that uses the median instead of the mean.
#' - `"MBF"` The modified Brown–Forsythe test proposed by Mehrotra (1997),
#'   which adjusts the degrees of freedom and consequently yields an approximate
#'   F-distribution of F(f1, f2) rather than F(k - 1, N - k). Compared with the
#'   original version (`BF`), this modification tends to reduce the Type I error
#'   rate at the cost of a higher Type II error rate.
#'
#' @return A list containing the test statistics, p-value, degrees of freedom,
#'         and optionally a summary table and/or auxiliary parameters,
#'         depending on the values of `summary` and `misc`.
#'
#' @examples
#' df0 <- roGFP[[1]]
#' out <- Brown_Forsythe_test(df0, ro ~ grp)
#' boxplot(ro ~ grp, df0, horizontal = TRUE)
#' points(x = df0$ro, y = jitter(as.numeric(df0$grp), amount = 0.15))
#' @references
#' Brown, M. B., & Forsythe, A. B. (1974).
#' Robust tests for the equality of variances.
#' Journal of the American Statistical Association, 69(346), 364–367.
#' https://doi.org/10.1080/01621459.1974.10482955
#'
#' Mehrotra, D. V. (1997).
#' Improving the Brown–Forsythe solution to the generalized Behrens–Fisher problem.
#' Communications in Statistics—Simulation and Computation, 26, 1139–1145.
#' https://doi.org/10.1080/03610919708813431
#' @seealso [Levene_test]
#' @export
Brown_Forsythe_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = FALSE,
        misc = FALSE,
        transform = function(x) abs(x - stats::median(x)),
        method = c("MBF", "BF")
) {
    method <- match.arg(toupper(method[1]), c("MBF", "BF"))

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
    yij <- unlist(y_prime, use.names = FALSE)
    df0[["y'"]] <- yij

    ni <- unlist(lapply(y_prime, length))
    grp_var <- unlist(lapply(y_prime, stats::var))
    grp_mean <- unlist(lapply(y_prime, mean))
    grand_mean <- mean(yij)

    #--------------------------------------------------------------------------#
    #                    Degree of freedom modification                        #
    #--------------------------------------------------------------------------#
    if (method == "MBF")
    {
        f1_num <- (sum(grp_var) - (sum(ni * grp_var) / N)) ^ 2
        f1_denom <- sum(grp_var ^ 2)
        f1_denom <- f1_denom + ((sum(ni * grp_var) / N) ^ 2)
        f1_denom <- f1_denom - (2 * (sum(ni * grp_var ^ 2) / N))

        f2_num <- sum( (1 - (ni / N)) * grp_var ) ^ 2
        f2_denom <- sum( ((1 - ni / N) ^ 2) * (grp_var ^ 2) / (ni - 1) )

        DF_between <- f1_num / f1_denom
        DF_within <- f2_num / f2_denom
        DF_total <- DF_between + DF_within
    }

    if (method == "BF")
    {
        ci <- (1 - ni / N) * grp_var
        ci <- ci / sum(ci)
        DF_within <- 1 / sum(ci * ci / (ni - 1))
        DF_between <- k - 1
        DF_total <- DF_between + DF_within
    }

    MS_between <- sum(ni * (grp_mean - grand_mean) ^ 2)
    MS_within <- sum((1 - ni / N) * grp_var)

    SS_between <- MS_between * DF_between
    SS_within <- MS_within * DF_within
    SS_total <- SS_between + SS_within

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

    test_name <- if (method == "MBF") "Modified Brown-Forsythe" else "Brown-Forsythe"

    ret <- varequal_standard_output(
        method = sprintf("%s homogeneity of variance test", test_name),
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
            "DF" = as.character(round(aov_tab[["DF"]], 2)),
            "SS" = as.character(round(aov_tab[["SS"]], 2)),
            "MS" = as.character(round(aov_tab[["MS"]], 2)),
            "Fvalue" = as.character(round(aov_tab[["Fvalue"]], 4)),
            "pvalue" = as.character(round(aov_tab[["pvalue"]], 5))
        )

        show_aov[is.na(show_aov)] <- ""

        cat("\n--------------------------------------------\n")
        cat("Brown-Forsythe homogeneity of variance test\n\n")
        cat(sprintf("Response: %s\n\n", y_name))
        print(show_aov)
        cat(sprintf("\n#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")))
        cat("\n--------------------------------------------\n")
    }

    invisible(ret)
}



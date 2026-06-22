#' Brown-Forsythe Test of Homogeneity of Variances
#'
#' Performs Brown-Forsythe test to assess the null hypothesis that the variances
#' are equal across all groups (samples) defined by the independent variable. This
#' test is essentially Levene's test using medians from the various groups.
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
#' @examples
#' plasma_etching <- data.frame(
#'     etch_rate = c(575, 542, 530, 539, 570,
#'                   565, 593, 590, 579, 610,
#'                   600, 651, 610, 637, 629,
#'                   725, 700, 715, 685, 710),
#'     power = as.character(rep(c(160, 180, 200, 220), each = 5))
#' )
#' Brown_Forsythe_test(plasma_etching, etch_rate ~ power)
#' @references
#' Brown, M. B., & Forsythe, A. B. (1974).
#' Robust tests for the equality of variances.
#' Journal of the American Statistical Association, 69(346), 364–367.
#' https://doi.org/10.1080/01621459.1974.10482955
#' @seealso [Levene_test()]
#' @export
Brown_Forsythe_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)
    x_name <- colnames(df0)[2]
    y_name <- colnames(df0)[1]

    diff <- tapply(df0[["y"]],
                   df0[["x"]],
                   function(xi) abs(xi - stats::median(xi)))
    df0[["diff"]] <- unlist(diff, use.names = FALSE)

    lm_mod <- stats::aov(diff ~ x, data = df0)
    aov_mod <- stats::anova(lm_mod)
    DF1 <- aov_mod[["Df"]][[1]]
    DF2 <- aov_mod[["Df"]][[2]]
    Fval <- aov_mod[["F value"]][[1]]
    pval <- aov_mod[["Pr(>F)"]][[1]]
    Fcrit <- stats::pf(alpha, DF1, DF2, lower.tail = FALSE)
    signif <- pval2asterisk(pval, alpha)

    aov_tab <- data.frame(
        check.names = FALSE,
        row.names = c(x_name, "Residuals"),
        "Df" = aov_mod[["Df"]],
        "SS" = aov_mod[["Sum Sq"]],
        "MSE" = aov_mod[["Mean Sq"]],
        "F" = c(round(Fval, 4), NA_real_),
        "Fcrit" = c(round(Fcrit, 4), NA_real_),
        "pval" = c(round(pval, 5), NA_real_),
        "signif" = c(signif, NA_character_)
    )

    ret <- varequal_standard_output(
        method = "Brown-Forsythe homogeneity of variance test",
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
            "Diff" = df0
        )
    }

    if (isFALSE(silent))
    {
        cat("\n---------------------------------------\n",
            "Brown-Forsythe homogeneity of variance test\n\n",
            sprintf("F: %s\n", round(Fval, 4)),
            sprintf("p-value: %s\n\n", round(pval, 5)),
            sprintf("#> Group variances are %s.",
                    ifelse(pval > alpha, "equal", "unequal")),
            "\n---------------------------------------\n\n")
        cat("Analysis of Variance Table\n\n")
        cat(sprintf("Response: %s\n", y_name))
        print(aov_tab)
        cat("\n")
    }

    invisible(ret)
}



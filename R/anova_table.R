fisher_anova <- function(data, formula, alpha = 0.05)
{
    df0 <- tidy_to_dataframe(data, formula)
    xij <- df0[["x"]]
    yij <- df0[["y"]]

    y_total <- sum(yij)
    yi <- with(df0, tapply(y, x, sum))
    ni <- with(df0, tapply(y, x, length))
    N <- sum(ni)
    k <- length(ni)

    is_balance <- (length(unique(ni)) == 1)

    grp_means <- with(df0, tapply(y, x, mean))
    grand_mean <- mean(yij)

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

    DF_total <- N - 1
    DF_between <- k - 1
    DF_within <- N - k

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

    return(aov_tab)

    # # Testing
    # plasma_etching <- data.frame(
    #     etch_rate = c(575, 542, 530, 539, 570,
    #                   565, 593, 590, 579, 610,
    #                   600, 651, 610, 637, 629,
    #                   725, 700, 715, 685, 710),
    #     power = as.factor(rep(c(160, 180, 200, 220), each = 5))
    # )
    #
    # fisher_anova(plasma_etching, etch_rate ~ power)
}

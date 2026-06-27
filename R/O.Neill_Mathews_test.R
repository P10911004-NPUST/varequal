O.Neill_Mathews_test <- function(
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

    ni <- tapply(y, x, length)
    uij <- tapply(y, x, transform)

    # Page 86 & 87
    wi <- ni / (1 + (2 / pi) * (sqrt(ni * (ni - 2)) + asin(1 / (ni - 1)) - ni))
    wi_star <- 1 / (1 - (2 / (pi * (ni - 1))) * (sqrt(ni * (ni - 2)) + asin(1 / (ni - 1))))

    grp_means <- unlist(lapply(uij, mean))
    grp_SS <- unlist(lapply(1:k, function(i) sum((uij[[i]] - grp_means[i]) ^ 2)))
    grp_weighted_means <- unlist(lapply(1:k, function(i) sum(wi[i] * uij[[i]]) / sum(wi)))
    print(list(grp_SS))

    SS_between <- sum(wi * (grp_means - grp_weighted_means) ^ 2)
    SS_within <- sum(wi_star * grp_SS)

    DF_between <- k - 1
    DF_within <- N - k

    MS_between <- SS_between / DF_between
    MS_within <- SS_within / DF_within

    Fval <- MS_between / MS_within
    Fval_crit <- stats::qf(alpha, DF_between, DF_within, lower.tail = FALSE)
    pval <- stats::pf(Fval, DF_between, DF_within, lower.tail = FALSE)

    print(list(MS_between, MS_within, Fval, pval))
}

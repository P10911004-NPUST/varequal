varequal_standard_output <- function(
        method = "what test?",
        is_var_equal = logical(1),
        alpha = 0.05,
        alternative = c("two.sided", "less", "greater"),
        summary = NA,
        statistic = NA_real_,
        pvalue = NA_real_,
        signif = "",
        ...
) {
    list(
        "method" = method,
        "is_var_equal" = is_var_equal,
        "alpha" = alpha,
        "summary" = summary,
        "statistic" = statistic,
        "pvalue" = pvalue,
        "signif" = signif,
        ...
    )
}


tidy_to_dataframe <- function(data, formula = NULL)
{
    ret <- NULL

    if (is.recursive(data) & is.null(dim(data)))
    {
        data <- lapply(data, function(x) x[stats::complete.cases(x)])
        data <- data
        isub <- seq_along(data)
        grp <- names(data)
        if (is.null(grp)) grp <- isub
        lst <- lapply(
            isub,
            function(i)
            {
                vct <- data[[i]]
                vct <- vct[stats::complete.cases(vct)]
                if (is.null(vct) || length(vct) == 0)
                    df0 <- data.frame(y = NA_real_, x = grp[i])
                else
                    df0 <- data.frame(y = vct, x = grp[i])
            }
        )
        ret <- do.call(rbind.data.frame, lst)
        ret <- ret[stats::complete.cases(ret[["y"]]), ]
    }

    if (is.data.frame(data))
    {
        if (is.null(formula)) stop("Please specify the `formula`.")
        df0 <- stats::model.frame(formula, data, drop.unused.levels = TRUE)
        x_name <- colnames(df0)[2]
        y_name <- colnames(df0)[1]
        colnames(df0) <- c("y", "x")
        df0[["x"]] <- as.character(df0[["x"]])
        ret <- df0[stats::complete.cases(df0[["y"]]), ]
    }

    return(ret)
}


pval2asterisk <- function(x, alpha = 0.05)
{
    vapply(
        x,
        function(`_`)
        {
            if (`_` <= 0.001)
                return("\U273D\U273D\U273D")
            if (`_` <= 0.01 & `_` > 0.001)
                return("\U273D\U273D")
            if (`_` <= alpha & `_` > 0.01)
                return("\U273D")
            if (`_` > alpha)
                return("ns")
        },
        FUN.VALUE = character(1)
    )
}


VAR_pooled <- function(val, grp)
{
    N <- c(tapply(val, grp, length))
    VAR <- c(tapply(val, grp, stats::var))
    N_ratio <- (N - 1) / sum(N - 1)
    var_pooled <- sum(N_ratio * VAR)
    return(var_pooled)
}

Hartley_test <- function(
        data,
        formula,
        alpha = 0.05,
        simulation = 1e4,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)
    x_name <- colnames(df0)[2]
    y_name <- colnames(df0)[1]

    k <- length(unique(df0[["x"]])) # number of groups
    avg_i <- c(tapply(df0[["y"]], df0[["x"]], mean)) # sample size of each groups
    ni <- c(tapply(df0[["y"]], df0[["x"]], length)) # sample size of each groups
    N <- sum(ni) # total sample size
    Si2 <- c(tapply(df0[["y"]], df0[["x"]], stats::var)) # variance of each groups
    var_pooled <- ceiling(VAR_pooled(df0[["y"]], df0[["x"]]))
    Fval <- max(Si2) / min(Si2)

    return("Not yet")
}

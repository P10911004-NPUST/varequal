
# O_O: observe is homo, predict is homo
# O_X: observe is homo, predict is hetero
# X_X: observe is hetero, predict is hetero
# X_O: observe is hetero, predict is homo
tests_result <- list(
    "Ansari_Bradley_test"   = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "Bartlett_test"         = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "Brown_Forsythe_test"   = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "BF"                    = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "Fligner_Killeen_test"  = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "Levene_test"           = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "O.Brien_test"          = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0),
    "O.Neill_Mathews_test"  = c("O_O" = 0, "O_X" = 0, "X_X" = 0, "X_O" = 0)
)


test_normal_small_data <- function(nsim = 1000)
{
    # Sample size
    n1 <- as.integer(stats::runif(nsim, 3, 7))
    n2 <- as.integer(stats::runif(nsim, 3, 7))
    n3 <- as.integer(stats::runif(nsim, 3, 7))
    n4 <- as.integer(stats::runif(nsim, 3, 7))

    # Mean
    c1 <- as.integer(stats::runif(nsim, -100, 100))
    c2 <- as.integer(stats::runif(nsim, -100, 100))
    c3 <- as.integer(stats::runif(nsim, -100, 100))
    c4 <- as.integer(stats::runif(nsim, -100, 100))

    # Standard deviation
    s1 <- as.integer(stats::runif(nsim, 1, 2))
    s2 <- as.integer(stats::runif(nsim, 2, 3))
    s3 <- as.integer(stats::runif(nsim, 3, 4))
    s4 <- as.integer(stats::runif(nsim, 4, 5))

    BF <- function(data, silent = TRUE) Brown_Forsythe_test(data, silent = silent, method = "BF")

    res <- tests_result
    test_names <- names(res)

    for (i in 1:nsim)
    {
        homo <- list(A = stats::rnorm(n1[i], c1[i], 1),
                     B = stats::rnorm(n2[i], c2[i], 1),
                     C = stats::rnorm(n3[i], c3[i], 1),
                     D = stats::rnorm(n4[i], c4[i], 1))

        hetero <- list(A = stats::rnorm(n1[i], c1[i], s1[i]),
                       B = stats::rnorm(n2[i], c2[i], s2[i]),
                       C = stats::rnorm(n3[i], c3[i], s3[i]),
                       D = stats::rnorm(n4[i], c4[i], s4[i]))

        for (j in test_names)
        {
            func <- get(j)

            is_homo <- func(homo, silent = TRUE)[["is_var_equal"]]
            res[[j]]["O_O"] <- res[[j]]["O_O"] + is_homo
            res[[j]]["O_X"] <- res[[j]]["O_X"] + !is_homo

            is_homo <- func(hetero, silent = TRUE)[["is_var_equal"]]
            res[[j]]["X_X"] <- res[[j]]["X_X"] + !is_homo
            res[[j]]["X_O"] <- res[[j]]["X_O"] + is_homo
        }
    }

    df0 <- as.data.frame(t(as.data.frame(res)))
    df0[["Type 1 error (%)"]] <- with(df0, 100 * O_X / (O_O + O_X))
    df0[["Type 2 error (%)"]] <- with(df0, 100 * X_O / (X_X + X_O))
    df0[["Accuracy (%)"]] <- with(df0, 100 * (O_O + X_X) / (O_O + O_X + X_X + X_O))

    return(df0)
}


test_normal_moderate_data <- function(nsim = 1000)
{
    # Sample size
    n1 <- as.integer(stats::runif(nsim, 8, 20))
    n2 <- as.integer(stats::runif(nsim, 8, 20))
    n3 <- as.integer(stats::runif(nsim, 8, 20))
    n4 <- as.integer(stats::runif(nsim, 8, 20))

    # Mean
    c1 <- as.integer(stats::runif(nsim, -10, 10))
    c2 <- as.integer(stats::runif(nsim, -10, 10))
    c3 <- as.integer(stats::runif(nsim, -10, 10))
    c4 <- as.integer(stats::runif(nsim, -10, 10))

    # Standard deviation
    s1 <- as.integer(stats::runif(nsim, 1, 2))
    s2 <- as.integer(stats::runif(nsim, 2, 3))
    s3 <- as.integer(stats::runif(nsim, 3, 4))
    s4 <- as.integer(stats::runif(nsim, 4, 5))

    BF <- function(data, silent = TRUE) Brown_Forsythe_test(data, silent = silent, method = "BF")

    res <- tests_result
    test_names <- names(res)

    for (i in 1:nsim)
    {
        homo <- list(A = stats::rnorm(n1[i], c1[i], 1),
                     B = stats::rnorm(n2[i], c2[i], 1),
                     C = stats::rnorm(n3[i], c3[i], 1),
                     D = stats::rnorm(n4[i], c4[i], 1))

        hetero <- list(A = stats::rnorm(n1[i], c1[i], s1[i]),
                       B = stats::rnorm(n2[i], c2[i], s2[i]),
                       C = stats::rnorm(n3[i], c3[i], s3[i]),
                       D = stats::rnorm(n4[i], c4[i], s4[i]))

        for (j in test_names)
        {
            func <- get(j)

            is_homo <- func(homo, silent = TRUE)[["is_var_equal"]]
            res[[j]]["O_O"] <- res[[j]]["O_O"] + is_homo
            res[[j]]["O_X"] <- res[[j]]["O_X"] + !is_homo

            is_homo <- func(hetero, silent = TRUE)[["is_var_equal"]]
            res[[j]]["X_X"] <- res[[j]]["X_X"] + !is_homo
            res[[j]]["X_O"] <- res[[j]]["X_O"] + is_homo
        }
    }

    df0 <- as.data.frame(t(as.data.frame(res)))
    df0[["Type 1 error (%)"]] <- with(df0, 100 * O_X / (O_O + O_X))
    df0[["Type 2 error (%)"]] <- with(df0, 100 * X_O / (X_X + X_O))
    df0[["Accuracy (%)"]] <- with(df0, 100 * (O_O + X_X) / (O_O + O_X + X_X + X_O))

    return(df0)
}


test_normal_moderate_outlying_data <- function(nsim = 1000)
{
    # Sample size
    n1 <- as.integer(stats::runif(nsim, 8, 20))
    n2 <- as.integer(stats::runif(nsim, 8, 20))
    n3 <- as.integer(stats::runif(nsim, 8, 20))
    n4 <- as.integer(stats::runif(nsim, 8, 20))

    # Mean
    c1 <- as.integer(stats::runif(nsim, -2, 2))
    c2 <- as.integer(stats::runif(nsim, -2, 2))
    c3 <- as.integer(stats::runif(nsim, -2, 2))
    c4 <- as.integer(stats::runif(nsim, -2, 2))

    # Standard deviation
    s1 <- as.integer(stats::runif(nsim, 1, 2))
    s2 <- as.integer(stats::runif(nsim, 2, 3))
    s3 <- as.integer(stats::runif(nsim, 3, 4))
    s4 <- as.integer(stats::runif(nsim, 4, 5))

    BF <- function(data, silent = TRUE) Brown_Forsythe_test(data, silent = silent, method = "BF")

    res <- tests_result
    test_names <- names(res)

    for (i in 1:nsim)
    {
        homo <- list(A = c(stats::rnorm(n1[i], c1[i], 1), 20),
                     B = c(stats::rnorm(n2[i], c2[i], 1), -20, -13),
                     C = stats::rnorm(n3[i], c3[i], 1),
                     D = stats::rnorm(n4[i], c4[i], 1))

        hetero <- list(A = stats::rnorm(n1[i], c1[i], s1[i]),
                       B = stats::rnorm(n2[i], c2[i], s2[i]),
                       C = stats::rnorm(n3[i], c3[i], s3[i]),
                       D = stats::rnorm(n4[i], c4[i], s4[i]))

        hetero[3:4] <- lapply(
            hetero[3:4],
            function(x)
            {
                max_x <- max(x)
                outliers <- max_x + 1.5 * max_x
                ret <- append(x, outliers)
                return(ret)
            }
        )

        for (j in test_names)
        {
            func <- get(j)

            is_homo <- func(homo, silent = TRUE)[["is_var_equal"]]
            res[[j]]["O_O"] <- res[[j]]["O_O"] + is_homo
            res[[j]]["O_X"] <- res[[j]]["O_X"] + !is_homo

            is_homo <- func(hetero, silent = TRUE)[["is_var_equal"]]
            res[[j]]["X_X"] <- res[[j]]["X_X"] + !is_homo
            res[[j]]["X_O"] <- res[[j]]["X_O"] + is_homo
        }
    }

    df0 <- as.data.frame(t(as.data.frame(res)))
    df0[["Type 1 error (%)"]] <- with(df0, 100 * O_X / (O_O + O_X))
    df0[["Type 2 error (%)"]] <- with(df0, 100 * X_O / (X_X + X_O))
    df0[["Accuracy (%)"]] <- with(df0, 100 * (O_O + X_X) / (O_O + O_X + X_X + X_O))

    return(df0)
}

# Testing ====

if (FALSE)
{
    system.time(out <- test_normal_small_data())
    system.time(out <- test_normal_moderate_data())
    system.time(out <- test_normal_moderate_outlying_data())

}

# Summary:
# 1. Bartlett test is the most robust test for normally distributed data.
# 2. If outliers exist, Fligner-Killeen test is more robust, Levene and BF are acceptable;
#    Bartlett's test is very susceptible to outliers.
# 3. None of the tests can handle small sample size data nicely.

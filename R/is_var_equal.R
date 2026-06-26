is_var_equal <- function(
        data,
        formula = NULL,
        alpha = 0.05,
        sensitivity = 2,
        summary = FALSE
) {
    df0 <- tidy_to_dataframe(data, formula)

    LV <- Levene_test(data, formula, alpha, silent = TRUE)
    BF <- Brown_Forsythe_test(data, formula, alpha, silent = TRUE)
    FK <- Fligner_Killeen_test(data, formula, alpha, silent = TRUE)
}

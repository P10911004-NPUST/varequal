#' Fligner-Killeen Test of Homogeneity of Variances
#'
#' Performs Fligner-Killeen test to assess the null hypothesis that the variances
#' are equal across all groups (samples) defined by the independent variable.
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
#'     power = rep(c(160, 180, 200, 220), each = 5)
#' )
#' Fligner_Killeen_test(plasma_etching, etch_rate ~ power)
#' @references
#' Fligner, M. A., & Killeen, T. J. (1976).
#' Distribution-free two-sample tests for scale.
#' Journal of the American Statistical Association, 71(353), 210–213.
#' https://doi.org/10.1080/01621459.1976.10481517
#' @seealso [stats::fligner.test()]
#' @export
Fligner_Killeen_test <- function(
        data,
        formula,
        alpha = 0.05,
        silent = FALSE,
        summary = TRUE,
        misc = FALSE
) {
    return("Not yet")
}

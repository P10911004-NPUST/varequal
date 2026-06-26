#' Cell number
#'
#' A dataset containing cortex cell counts within the meristematic zone of roots
#' in an *Arabidopsis thaliana* transgenic plant (CYCB1;3-GFP).
#'
#' @format A list containing three data frames, each representing a different experimental batch:
#' \describe{
#'   \item{TEMP}{Air temperature in degrees Celsius}
#'   \item{RGF1}{Concentration of RGF1 peptide hormone treatment (0 nM, 5 nM)}
#'   \item{treatment}{TEMP x RGF1 -> 4 groups of treatments}
#'   \item{grp}{Handy labels for each treatment (A, B, C, D)}
#'   \item{cells}{Number of meristematic root cells}
#' }
"CYCB1"


#' RO index
#'
#' A dataset containing the reduced–oxidized (RO) index computed from confocal
#' fluorescence images of roots of an *Arabidopsis thaliana* transgenic plant
#' (cytRGX–roGFP2).
#'
#' @format A list containing three data frames, each representing a different experimental batch:
#' \describe{
#'   \item{TEMP}{Air temperature in degrees Celsius (22C and 31C)}
#'   \item{RGF1}{Concentration of RGF1 peptide hormone treatment (0nM, 5nM)}
#'   \item{treatment}{TEMP x RGF1 -> 4 groups of treatments}
#'   \item{grp}{Handy labels for each treatment (A, B, C, D)}
#'   \item{ro}{Redox index ranging from -1 (reduced) to 1 (oxidized)}
#' }
"roGFP"

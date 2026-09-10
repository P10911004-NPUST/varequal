# Redox (RO) index

A dataset containing the reduced–oxidized (RO) index computed from
confocal fluorescence images of roots of an *Arabidopsis thaliana*
transgenic plant (cytRGX–roGFP2).

## Usage

``` r
roGFP
```

## Format

A list containing three data frames, each representing a different
experimental batch:

- TEMP:

  Air temperature in degrees Celsius (22C and 31C)

- RGF1:

  Concentration of RGF1 peptide hormone treatment (0nM, 5nM)

- treatment:

  TEMP x RGF1 -\> 4 groups of treatments

- grp:

  Labels for each treatment groups (A, B, C, D)

- ro:

  Redox index ranging from -1 (reduced) to 1 (oxidized)

## References

Hsiao, Y., Lai, J., Shiue, S., & Yamada, M. (2026). RGF signaling
bridges root development and nonlethal thermal stress adaptation. New
Phytologist, nph.71392. https://doi.org/10.1111/nph.71392

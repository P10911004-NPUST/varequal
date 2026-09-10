# Cell number

A dataset containing cortex cell counts within the meristematic zone of
roots in an *Arabidopsis thaliana* transgenic plant (CYCB1;3-GFP).

## Usage

``` r
CYCB1
```

## Format

A list containing three data frames, each representing a different
experimental batch:

- TEMP:

  Air temperature in degrees Celsius

- RGF1:

  Concentration of RGF1 peptide hormone treatment (0 nM, 5 nM)

- treatment:

  TEMP x RGF1 -\> 4 groups of treatments

- grp:

  Labels for each treatment groups (A, B, C, D)

- cells:

  Number of meristematic root cells

## References

Hsiao, Y., Lai, J., Shiue, S., & Yamada, M. (2026). RGF signaling
bridges root development and nonlethal thermal stress adaptation. New
Phytologist, nph.71392. https://doi.org/10.1111/nph.71392

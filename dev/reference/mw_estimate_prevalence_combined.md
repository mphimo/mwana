# Estimate the prevalence of combined wasting

Estimate the prevalence of wasting based on the combined case-definition
of weight-for-height z-scores (WFHZ), MUAC and/or oedema. The function
allows users to estimate prevalence in accordance with complex-sample
design properties such as accounting for survey sample weights when
needed or applicable.

The data quality is first assessed by calculating and rating the
standard deviation (SD) of WFHZ. Then it calculates the observed
proportion of children aged 24–59 months out of all children in the
dataset. Next, it estimates the p-value for the difference between this
observed proportion and the expected (0.66), and rates the result.

Prevalence is estimated only when the WFHZ SD is not problematic and the
age ratio test is not problematic, or — if the age ratio test is
problematic — the proportion of children aged 24–59 months is greater
than or equal to 0.66.

## Usage

``` r
mw_estimate_prevalence_combined(df, wt = NULL, oedema = NULL, ...)
```

## Arguments

- df:

  A `tibble` object produced by sequential application of the
  [`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_wfhz.md)
  and
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md).
  Note that MUAC values in `df` must be in millimetres unit after using
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md).
  In addition, `df` must have a variable called `cluster`, which
  contains the primary sampling unit identifiers.

- wt:

  A vector of class `double` of the survey sampling weights. Default is
  NULL which assumes a self-weighted survey as is the case for a survey
  sample selected proportional to population size (i.e., SMART survey
  sample). Otherwise, a weighted analysis is implemented.

- oedema:

  A `character` vector for presence of nutritional oedema coded as "y"
  for presence of nutritional oedema and "n" for absence of nutritional
  oedema. Default is NULL.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A summary `tibble` for the descriptive statistics about combined
wasting.

## Details

A concept of *combined flags* is introduced in this function. Any
observation that is flagged for either `flag_wfhz` or `flag_mfaz` is
flagged under a new variable named `cflags` added to `df`. This ensures
that all flagged observations from both WFHZ and MFAZ data are excluded
from the prevalence analysis.

|               |               |            |
|---------------|---------------|------------|
| **flag_wfhz** | **flag_mfaz** | **cflags** |
| 1             | 0             | 1          |
| 0             | 1             | 1          |
| 0             | 0             | 0          |

## Examples

``` r
## When wt are set to NULL ----
mw_estimate_prevalence_combined(
  df = anthro.02,
  wt = NULL,
  oedema = oedema
)
#> # A tibble: 1 × 16
#>   cgam_n cgam_p cgam_p_low cgam_p_upp cgam_p_deff csam_n csam_p csam_p_low
#>    <dbl>  <dbl>      <dbl>      <dbl>       <dbl>  <dbl>  <dbl>      <dbl>
#> 1    143 0.0685     0.0566     0.0804         Inf     27 0.0129    0.00770
#> # ℹ 8 more variables: csam_p_upp <dbl>, csam_p_deff <dbl>, cmam_n <dbl>,
#> #   cmam_p <dbl>, cmam_p_low <dbl>, cmam_p_upp <dbl>, cmam_p_deff <dbl>,
#> #   N <dbl>

## When `wt` is not set to NULL ----
mw_estimate_prevalence_combined(
  df = anthro.02,
  wt = wtfactor,
  oedema = oedema
)
#> # A tibble: 1 × 16
#>   cgam_n cgam_p cgam_p_low cgam_p_upp cgam_p_deff csam_n csam_p csam_p_low
#>    <dbl>  <dbl>      <dbl>      <dbl>       <dbl>  <dbl>  <dbl>      <dbl>
#> 1    143 0.0708     0.0563     0.0853        1.72     27 0.0151    0.00750
#> # ℹ 8 more variables: csam_p_upp <dbl>, csam_p_deff <dbl>, cmam_n <dbl>,
#> #   cmam_p <dbl>, cmam_p_low <dbl>, cmam_p_upp <dbl>, cmam_p_deff <dbl>,
#> #   N <dbl>
```

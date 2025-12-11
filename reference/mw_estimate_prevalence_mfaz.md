# Estimate the prevalence of wasting based on z-scores of muac-for-age (MFAZ)

Calculate the prevalence estimates of wasting based on z-scores of
MUAC-for-age and/or bilateral oedema. The function allows users to
estimate prevalence in accordance with complex sample design properties
such as accounting for survey sample weights when needed or applicable.
The quality of the data is first evaluated by calculating and rating the
standard deviation of MFAZ. Standard approach to prevalence estimation
is calculated only when the standard deviation of MFAZ is rated as not
problematic. If the standard deviation is problematic, prevalence is
estimated using the PROBIT estimator. Outliers are detected based on
SMART flagging criteria. Identified outliers are then excluded before
prevalence estimation is performed.

## Usage

``` r
mw_estimate_prevalence_mfaz(df, wt = NULL, oedema = NULL, ...)
```

## Arguments

- df:

  A `data.frame` object that has been produced by the
  [`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
  and
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
  functions. The `df` should have a variable named `cluster` for the
  primary sampling unit identifiers.

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

A summary `tibble` for the descriptive statistics about wasting.

## Examples

``` r
## Without grouping variables ----
mw_estimate_prevalence_mfaz(
  df = anthro.04,
  wt = NULL,
  oedema = oedema
)
#> # A tibble: 1 × 16
#>   gam_n gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p sam_p_low sam_p_upp
#>   <dbl> <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>     <dbl>     <dbl>
#> 1   320 0.107    0.0873     0.127        Inf    43 0.0144   0.00894    0.0198
#> # ℹ 7 more variables: sam_p_deff <dbl>, mam_n <dbl>, mam_p <dbl>,
#> #   mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>, wt_pop <dbl>

## With grouping variables ----
mw_estimate_prevalence_mfaz(
  df = anthro.04,
  wt = NULL,
  oedema = oedema,
  province
)
#> # A tibble: 3 × 17
#>   province   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p sam_p_low
#>   <chr>      <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>     <dbl>
#> 1 Province 1   152 0.119     0.0851     0.153        Inf    13 0.0102   0.00132
#> 2 Province 2    95 0.0854    0.0565     0.114        Inf    13 0.0117   0.00510
#> 3 Province 3    NA 0.257    NA         NA             NA    NA 0.0491  NA      
#> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
#> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
#> #   wt_pop <dbl>
```

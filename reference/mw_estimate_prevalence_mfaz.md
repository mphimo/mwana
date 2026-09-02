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
anthro.04 |>
  mw_wrangle_age(age = age) |>
  mw_wrangle_muac(
    muac = muac,
    .recode_muac = TRUE,
    .to = "cm",
    age = age,
    sex = sex,
    .recode_sex = FALSE
  ) |>
  transform(muac = recode_muac(muac, "mm")) |>
  mw_estimate_prevalence_mfaz(
    wt = NULL,
    oedema = oedema,
    analysis_unit
  )
#> ================================================================================
#> # A tibble: 3 × 17
#>   analysis_unit gam_n gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p
#>   <chr>         <dbl> <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>
#> 1 Unit A           68 0.112    0.0776     0.147        Inf     9 0.0149
#> 2 Unit B          286 0.211    0.169      0.253        Inf    59 0.0436
#> 3 Unit C           NA 0.339   NA         NA             NA    NA 0.0786
#> # ℹ 9 more variables: sam_p_low <dbl>, sam_p_upp <dbl>, sam_p_deff <dbl>,
#> #   mam_n <dbl>, mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>,
#> #   mam_p_deff <dbl>, N <dbl>
```

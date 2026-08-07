# Estimate the prevalence of wasting based on MUAC for survey data

Estimate the prevalence of wasting based on MUAC and/or nutritional
oedema. The function allows users to estimate prevalence in accordance
with complex sample design properties, such as accounting for survey
sample weights when needed or applicable.

It first evaluates the quality of the data to determine the appropriate
prevalence-analysis flow to be employed. Quality is evaluated by
estimating the observed proportion of children aged 24-59 months of the
total children in the dataset, then it estimates the p-value for the
difference between the above-mentioned category against the expected
(0.66) and rates it.

If age ratio test is "problematic" and the proportion of children aged
24-59 months is \< 0.66, age-weighting approach is applied to prevalence
estimation, to account for the over-representation of younger children
in the sample; otherwise, a non-age-weighted prevalence is estimated.

## Usage

``` r
mw_estimate_prevalence_muac(df, age, muac, wt = NULL, oedema = NULL, ...)
```

## Arguments

- df:

  A `tibble` object produced by
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md)
  and
  [`mw_wrangle_age()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_age.md)
  functions. Note that MUAC values in `df` must be in millimetres after
  using
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md).
  Also, `df` must have a variable called `cluster` wherein the primary
  sampling unit identifiers are stored.

- age:

  A vector of class `double` of child's age in months.

- muac:

  A `numeric` or `integer` vector of raw MUAC values. The measurement
  unit should be millimetres.

- wt:

  A vector of class `double` of the survey sampling weights. Default is
  NULL, which assumes a self-weighted survey, the case of SMART surveys.
  Otherwise, a weighted analysis is implemented.

- oedema:

  A `character` vector for presence of nutritional oedema Code values
  should be "y" for presence and "n" for absence. Default is NULL.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A summary `tibble` for the descriptive statistics about wasting based on
MUAC, with confidence intervals.

## Details

A typical user analysis workflow is expected to begin with data quality
checks, followed by a thorough review, and only thereafter proceed to
prevalence estimation. This sequence places the user in the strongest
position to assess whether the resulting prevalence estimates are
reliable.

Outliers are identified using SMART flagging criteria applied to MFAZ,
and are excluded from the prevalence estimation.

## References

SMART Initiative (no date). *Updated MUAC data collection tool*.
Available at:
<https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>

## See also

[`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_estimate_age_weighted_prev_muac.md)
[`mw_estimate_prevalence_mfaz()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_estimate_prevalence_mfaz.md)
[`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/dev/dev/reference/muac-screening.md)

## Examples

``` r

## Ungrouped analysis ----
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
  mw_estimate_prevalence_muac(
    muac = muac,
    age = age,
    wt = NULL,
    oedema = oedema,
    analysis_unit
  )
#> ================================================================================
#> # A tibble: 3 × 17
#>   analysis_unit gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p
#>   <chr>         <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>
#> 1 Unit A           39 0.0644    0.0389    0.0898        Inf     7 0.0116
#> 2 Unit B           NA 0.121    NA        NA              NA    NA 0.0293
#> 3 Unit C           19 0.0909    0.0492    0.133         Inf     5 0.0239
#> # ℹ 9 more variables: sam_p_low <dbl>, sam_p_upp <dbl>, sam_p_deff <dbl>,
#> #   mam_n <dbl>, mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>,
#> #   mam_p_deff <dbl>, N <dbl>
```

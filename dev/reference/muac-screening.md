# Estimate the prevalence of wasting based on MUAC for non-survey data

It is common to estimate prevalence of wasting from non-survey data,
such as screenings or any other data derived from community-based
surveillance systems. In such situations, the analysis usually consists
only in estimating the point prevalence and the counts of positive
cases, without necessarily estimating the uncertainty. This function
serves this purpose.

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
mw_estimate_prevalence_screening(df, muac, age, oedema = NULL, ...)

mw_estimate_prevalence_screening2(df, age_cat, muac, oedema = NULL, ...)
```

## Arguments

- df:

  A `tibble` object produced by
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md)
  and
  [`mw_wrangle_age()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_age.md)
  functions. Note that MUAC values in `df` must be in millimetres unit
  after using
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_wrangle_muac.md).
  Also, `df` must have a variable called `cluster` wherein the primary
  sampling unit identifiers are stored.

- muac:

  A `numeric` or `integer` vector of raw MUAC values. The measurement
  unit should be millimetres.

- age:

  A vector of class `double` of child's age in months.

- oedema:

  A `character` vector for presence of nutritional oedema. Code values
  should be "y" for presence and "n" for absence. Default is NULL.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

- age_cat:

  A `character` vector of child's age in categories. Code values should
  be "6-23" and "24-59".

## Value

A summary `tibble` for the descriptive statistics about wasting based on
MUAC, with no confidence intervals.

## Details

A typical user analysis workflow is expected to begin with data quality
checks, followed by a thorough review, and only thereafter proceed to
prevalence estimation. This sequence places the user in the strongest
position to assess whether the resulting prevalence estimates are
reliable.

In `mw_estimate_prevalence_screening()`, outliers are identified using
SMART flagging criteria applied to MFAZ, whereas in
`mw_estimate_prevalence_screening2()` are based on the raw MUAC values.
In either functions, outliers are excluded from the prevalence
estimation.

## References

SMART Initiative (no date). *Updated MUAC data collection tool*.
Available at:
<https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>

## See also

[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_estimate_prevalence_muac.md),
[`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_estimate_age_weighted_prev_muac.md),
[`flag_outliers()`](https://mphimo.github.io/mwana/dev/dev/reference/outliers.md)
and
[`remove_flags()`](https://mphimo.github.io/mwana/dev/dev/reference/outliers.md).

## Examples

``` r
mw_estimate_prevalence_screening(
  df = anthro.02,
  muac = muac,
  age = age,
  oedema = oedema,
  province
)
#> # A tibble: 2 × 8
#>   province gam_n  gam_p sam_n   sam_p mam_n  mam_p     N
#>   <chr>    <dbl>  <dbl> <dbl>   <dbl> <dbl>  <dbl> <int>
#> 1 Nampula     61 0.0590    19 0.0184     42 0.0406  1034
#> 2 Zambezia    57 0.0500    10 0.00876    47 0.0412  1141

## With `oedema` set to `NULL` ----
mw_estimate_prevalence_screening(
  df = anthro.02,
  muac = muac,
  age = age,
  oedema = NULL,
  province
)
#> # A tibble: 2 × 8
#>   province gam_n  gam_p sam_n   sam_p mam_n  mam_p     N
#>   <chr>    <dbl>  <dbl> <dbl>   <dbl> <dbl>  <dbl> <int>
#> 1 Nampula     53 0.0513    10 0.00967    43 0.0416  1034
#> 2 Zambezia    53 0.0465     6 0.00526    47 0.0412  1141

## Specifying the grouping variables ----
mw_estimate_prevalence_screening(
  df = anthro.02,
  muac = muac,
  age = age,
  oedema = NULL,
  province
)
#> # A tibble: 2 × 8
#>   province gam_n  gam_p sam_n   sam_p mam_n  mam_p     N
#>   <chr>    <dbl>  <dbl> <dbl>   <dbl> <dbl>  <dbl> <int>
#> 1 Nampula     53 0.0513    10 0.00967    43 0.0416  1034
#> 2 Zambezia    53 0.0465     6 0.00526    47 0.0412  1141


anthro.01 |>
  mw_wrangle_muac(
    sex = sex,
    .recode_sex = TRUE,
    muac = muac
  ) |>
  transform(
    age_cat = ifelse(age < 24, "6-23", "24-59")
  ) |>
  mw_estimate_prevalence_screening2(
    age_cat = age_cat,
    muac = muac,
    oedema = oedema,
    area
  )
#> # A tibble: 2 × 8
#>   area       gam_n  gam_p sam_n   sam_p mam_n  mam_p     N
#>   <chr>      <dbl>  <dbl> <dbl>   <dbl> <dbl>  <dbl> <int>
#> 1 District E    13 0.0257     0 0          13 0.0257   505
#> 2 District G    23 0.0337     4 0.00586    19 0.0278   683
```

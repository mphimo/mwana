# Estimate age-weighted prevalence of wasting by MUAC

Estimates age‑weighted prevalence of wasting using MUAC. Accepts age in
months or in categories ('6–23', '24–59'). The default is age in months.

The prevalence is weighted as: \$\$( prevalence\_{6-23} + (2 \times
prevalence\_{24-59} )) / 3\$\$

Whilst the function is exported to users as a standalone, it is embedded
into the following major MUAC prevalence functions of this package:
[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/dev/reference/mw_estimate_prevalence_muac.md),
[`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/dev/dev/reference/muac-screening.md),
and
[`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/dev/dev/reference/muac-screening.md).

## Usage

``` r
mw_estimate_age_weighted_prev_muac(
  df,
  muac,
  has_age = TRUE,
  age = NULL,
  age_cat = NULL,
  oedema = NULL,
  raw_muac = FALSE,
  ...
)
```

## Arguments

- df:

  A `tibble` object produced by `mwana` data wranglers.

- muac:

  A `numeric` or `integer` vector of raw MUAC values. The measurement
  unit should be millimetres.

- has_age:

  Logical. Specifies whether the input dataset provides age in months or
  in categories ('6–23', '24–59'). Defaults to `TRUE` when age is given
  in months.

- age:

  A vector of class `double` of child's age in months. Defaults to NULL.
  Only use if `has_age = TRUE`, otherwise set it to `NULL`.

- age_cat:

  A `character` vector of child's age in categories. Code values should
  be "6-23" and "24-59". Defaults to `NULL`. Only use it if
  `has_age = FALSE`.

- oedema:

  A `character` vector for presence of nutritional oedema. Code values
  should be "y" for presence and "n" for absence. Defaults to NULL.

- raw_muac:

  Logical. Whether outliers should be excluded based on the raw MUAC
  values or MFAZ. For the former, set it to `TRUE`, otherwise `FALSE`.
  Defaults to MFAZ.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A summary `tibble` with wasting prevalence estimates, as given by the
SMART updated MUAC tool (see references below).

## Details

As a standalone function, the user must check data quality before
calling the function.

## References

SMART Initiative (no date). *Updated MUAC data collection tool*.
Available at:
<https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>

## Examples

``` r
## Example application when age is given in months ----
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
  mw_estimate_age_weighted_prev_muac(
    muac = muac,
    has_age = TRUE,
    age = age,
    age_cat = FALSE,
    oedema = oedema,
    raw_muac = FALSE,
    analysis_unit
  )
#> ================================================================================
#> # A tibble: 3 × 13
#>   analysis_unit u2oedema  u2sam u2mam u2gam o2oedema   o2sam  o2mam  o2gam
#>   <chr>            <dbl>  <dbl> <dbl> <dbl>    <dbl>   <dbl>  <dbl>  <dbl>
#> 1 Unit A               0 0.0368 0.121 0.158        0 0       0.0216 0.0216
#> 2 Unit B               0 0.0748 0.218 0.292        0 0.00665 0.0293 0.0359
#> 3 Unit C               0 0.0851 0.128 0.213        0 0.00617 0.0494 0.0556
#> # ℹ 4 more variables: sam_p <dbl>, mam_p <dbl>, gam_p <dbl>, N <int>

## Example application when age is given in categories ----
anthro.04 |>
  transform(age_cat = ifelse(age < 24, "6-23", "24-59")) |>
  mw_wrangle_muac(
    muac = muac,
    .recode_muac = FALSE,
    .to = "none",
    sex = sex,
    .recode_sex = FALSE
  ) |>
  mw_estimate_age_weighted_prev_muac(
    has_age = FALSE,
    age = NULL,
    age_cat = age_cat,
    oedema = oedema,
    raw_muac = TRUE
  )
#> Warning: Using `by = character()` to perform a cross join was deprecated in dplyr 1.1.0.
#> ℹ Please use `cross_join()` instead.
#> ℹ The deprecated feature was likely used in the mwana package.
#>   Please report the issue at <https://github.com/mphimo/mwana/issues>.
#> # A tibble: 1 × 12
#>   u2oedema  u2sam u2mam u2gam o2oedema   o2sam  o2mam  o2gam  sam_p  mam_p gam_p
#>      <dbl>  <dbl> <dbl> <dbl>    <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl>
#> 1        0 0.0718 0.188 0.260        0 0.00747 0.0291 0.0366 0.0289 0.0823 0.111
#> # ℹ 1 more variable: N <int>
```

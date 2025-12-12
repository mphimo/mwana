# Estimate age-weighted prevalence of wasting by MUAC

Estimates age‑weighted prevalence of wasting using MUAC. Accepts age in
months or in categories ('6–23', '24–59'). The default is age in months.

The prevalence is weighted as: \$\$ \frac{
\mathrm{prevalence}\_{6\text{--}23} + 2 \times
\mathrm{prevalence}\_{24\text{--}59} }{3} \$\$

Whilst the function is exported to users as a standalone, it is embedded
into the following major MUAC prevalence functions of this package:
[`mw_estimate_prevalence_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_estimate_prevalence_muac.md),
[`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md),
and
[`mw_estimate_prevalence_screening2()`](https://mphimo.github.io/mwana/dev/reference/muac-screening.md).

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
mw_estimate_age_weighted_prev_muac(
  df = anthro.04,
  muac = muac,
  has_age = TRUE,
  age = age,
  age_cat = FALSE,
  oedema = oedema,
  raw_muac = FALSE,
  province
)
#> # A tibble: 3 × 12
#>   province   oedema_u2  u2sam u2mam u2gam oedema_o2   o2sam  o2mam  o2gam    sam
#>   <chr>          <dbl>  <dbl> <dbl> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>  <dbl>
#> 1 Province 1         0 0.0328 0.176 0.209         0 0.00127 0.0380 0.0393 0.0118
#> 2 Province 2         0 0.0369 0.165 0.202         0 0.00368 0.0239 0.0276 0.0148
#> 3 Province 3         0 0.0678 0.142 0.209         0 0.00763 0.0534 0.0611 0.0277
#> # ℹ 2 more variables: mam <dbl>, gam <dbl>

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
    raw_muac = FALSE
  )
#> # A tibble: 1 × 11
#>   oedema_u2  u2sam u2mam u2gam oedema_o2   o2sam  o2mam  o2gam    sam    mam
#>       <dbl>  <dbl> <dbl> <dbl>     <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#> 1         0 0.0430 0.163 0.206         0 0.00313 0.0357 0.0389 0.0164 0.0783
#> # ℹ 1 more variable: gam <dbl>
```

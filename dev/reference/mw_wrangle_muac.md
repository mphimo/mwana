# Wrangle MUAC data

Calculate z-scores for MUAC-for-age (MFAZ) and identify outliers based
on the SMART methodology. When age is not supplied, only outliers are
detected from the raw MUAC values. The function only works after age has
gone through
[`mw_wrangle_age()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_age.md).

## Usage

``` r
mw_wrangle_muac(
  df,
  sex,
  muac,
  age = NULL,
  .recode_sex = TRUE,
  .recode_muac = TRUE,
  .to = c("cm", "mm", "none"),
  .decimals = 3
)
```

## Arguments

- df:

  A `data.frame` object to wrangle data from.

- sex:

  A `numeric` or `character` vector of child's sex. Code values should
  only be 1 or "m" for males and 2 or "f" for females.

- muac:

  A `numeric` vector of child's age in months.

- age:

  A `numeric` vector of child's age in months. Default is NULL.

- .recode_sex:

  Logical. Set to TRUE if the values for `sex` are not coded as 1 (for
  males) or 2 (for females). Otherwise, set to FALSE (default).

- .recode_muac:

  Logical. Set to TRUE if the values for raw MUAC should be converted to
  either centimetres or millimetres. Otherwise, set to FALSE (default)

- .to:

  A choice of the measuring unit to convert MUAC values into. Can be
  "cm" for centimetres, "mm" for millimetres, or "none" to leave as it
  is.

- .decimals:

  The number of decimal places to use for z-score outputs. Default is 3.

## Value

A `tibble` based on `df`. If `age = NULL`, `flag_muac` variable for
detected MUAC outliers based on raw MUAC is added to `df`. Otherwise,
variables named `mfaz` for child's MFAZ and `flag_mfaz` for detected
outliers based on SMART guidelines are added to `df`.

## References

Bilukha, O., & Kianian, B. (2023). Considerations for assessment of
measurement quality of mid‐upper arm circumference data in
anthropometric surveys and mass nutritional screenings conducted in
humanitarian and refugee settings. *Maternal & Child Nutrition*, 19,
e13478. <https://doi.org/10.1111/mcn.13478>

SMART Initiative (2017). *Standardized Monitoring and Assessment for
Relief and Transition*. Manual 2.0. Available at:
<https://smartmethodology.org>.

## See also

[`flag_outliers()`](https://mphimo.github.io/mwana/dev/reference/outliers.md)
[`remove_flags()`](https://mphimo.github.io/mwana/dev/reference/outliers.md)
[`mw_wrangle_age()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_age.md)

## Examples

``` r
## When age is available, wrangle it first before calling the function ----
w <- mw_wrangle_age(
  df = anthro.02,
  dos = NULL,
  dob = NULL,
  age = age,
  .decimals = 2
)

### Then apply the function to wrangle MUAC data ----
mw_wrangle_muac(
  df = w,
  sex = sex,
  age = age,
  muac = muac,
  .recode_sex = TRUE,
  .recode_muac = TRUE,
  .to = "cm",
  .decimals = 3
)
#> ================================================================================
#> # A tibble: 2,267 × 15
#>    province strata cluster   sex   age weight height oedema  muac wtfactor
#>    <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>
#>  1 Zambezia Rural      391     2  6.01    8.2   68   n       15.2     825.
#>  2 Zambezia Rural      404     2  6.01    7.1   65.1 n       13.9     287.
#>  3 Zambezia Rural      399     2  6.11    7.6   64.1 n       15.5     130.
#>  4 Zambezia Urban      430     2  6.14    7.9   65.9 n       14.8    1277.
#>  5 Zambezia Urban      468     2  6.28    6.6   59.7 n       13.2     792.
#>  6 Zambezia Urban      517     2  6.34    6     61.8 n       12.9     480.
#>  7 Zambezia Urban      461     2  6.34    6.5   64.4 n       12.3     977.
#>  8 Zambezia Rural      382     2  6.41    6.5   63.4 n       12.6     165.
#>  9 Zambezia Urban      502     2  6.41    7.5   66   n       14.2    1083.
#> 10 Zambezia Urban      500     2  6.41    6.8   64.1 n       13.5     972.
#> # ℹ 2,257 more rows
#> # ℹ 5 more variables: wfhz <dbl>, flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>,
#> #   age_days <dbl>

## When age is not available ----
mw_wrangle_muac(
  df = anthro.02,
  sex = sex,
  age = NULL,
  muac = muac,
  .recode_sex = TRUE,
  .recode_muac = TRUE,
  .to = "cm",
  .decimals = 3
)
#> # A tibble: 2,267 × 15
#>    province strata cluster   sex   age weight height oedema  muac wtfactor
#>    <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>
#>  1 Zambezia Rural      391     2  6.01    8.2   68   n        152     825.
#>  2 Zambezia Rural      404     2  6.01    7.1   65.1 n        139     287.
#>  3 Zambezia Rural      399     2  6.11    7.6   64.1 n        155     130.
#>  4 Zambezia Urban      430     2  6.14    7.9   65.9 n        148    1277.
#>  5 Zambezia Urban      468     2  6.28    6.6   59.7 n        132     792.
#>  6 Zambezia Urban      517     2  6.34    6     61.8 n        129     480.
#>  7 Zambezia Urban      461     2  6.34    6.5   64.4 n        123     977.
#>  8 Zambezia Rural      382     2  6.41    6.5   63.4 n        126     165.
#>  9 Zambezia Urban      502     2  6.41    7.5   66   n        142    1083.
#> 10 Zambezia Urban      500     2  6.41    6.8   64.1 n        135     972.
#> # ℹ 2,257 more rows
#> # ℹ 5 more variables: wfhz <dbl>, flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>,
#> #   flag_muac <dbl>
```

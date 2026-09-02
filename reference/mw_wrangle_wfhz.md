# Wrangle weight-for-height data

Calculate z-scores for weight-for-height (WFHZ) and identify outliers
based on the SMART methodology.

## Usage

``` r
mw_wrangle_wfhz(df, sex, weight, height, .recode_sex = TRUE, .decimals = 3)
```

## Arguments

- df:

  A `data.frame` object to wrangle data from.

- sex:

  A `numeric` or `character` vector of child's sex. Code values should
  only be 1 or "m" for males and 2 or "f" for females.

- weight:

  A vector of class `double` of child's weight in kilograms.

- height:

  A vector of class `double` of child's height in centimetres.

- .recode_sex:

  Logical. Set to TRUE if the values for `sex` are not coded as 1 (for
  males) or 2 (for females). Otherwise, set to FALSE (default).

- .decimals:

  The number of decimal places to use for z-score outputs. Default is 3.

## Value

A data frame based on `df` with new variables named `wfhz` for child's
WFHZ and `flag_wfhz` for detected outliers added.

## References

SMART Initiative (2017). *Standardized Monitoring and Assessment for
Relief* *and Transition*. Manual 2.0. Available at:
<https://smartmethodology.org>.

## See also

[`flag_outliers()`](https://mphimo.github.io/mwana/dev/reference/outliers.md)
[`remove_flags()`](https://mphimo.github.io/mwana/dev/reference/outliers.md)

## Examples

``` r
mw_wrangle_wfhz(
  df = anthro.01,
  sex = sex,
  weight = weight,
  height = height,
  .recode_sex = TRUE,
  .decimals = 2
)
#> ================================================================================
#> # A tibble: 1,191 × 13
#>    area     dos        cluster  team   sex dob      age weight height oedema
#>    <chr>    <date>       <int> <int> <dbl> <date> <int>  <dbl>  <dbl> <chr> 
#>  1 Distric… 2023-12-04       1     3     1 NA        59   15.6  109.  n     
#>  2 Distric… 2023-12-04       1     3     1 NA         8    7.5   68.6 n     
#>  3 Distric… 2023-12-04       1     3     1 NA        19    9.7   79.5 n     
#>  4 Distric… 2023-12-04       1     3     2 NA        49   14.3  100.  n     
#>  5 Distric… 2023-12-04       1     3     2 NA        32   12.4   92.1 n     
#>  6 Distric… 2023-12-04       1     3     2 NA        17    9.3   77.8 n     
#>  7 Distric… 2023-12-04       1     3     2 NA        20   10.1   80.4 n     
#>  8 Distric… 2023-12-04       1     3     2 NA        27   11.7   87.1 n     
#>  9 Distric… 2023-12-04       1     3     1 NA        46   13.6   98   n     
#> 10 Distric… 2023-12-04       1     3     1 NA        58   17.2  109.  n     
#> # ℹ 1,181 more rows
#> # ℹ 3 more variables: muac <int>, wfhz <dbl>, flag_wfhz <dbl>
```

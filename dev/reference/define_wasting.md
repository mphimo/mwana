# Define wasting

Determine if a given observation in the dataset is wasted or not, and
its respective form of wasting (global, severe or moderate) on the basis
of z-scores of weight-for-height (WFHZ), muac-for-age (MFAZ), raw MUAC
values and combined case-definition.

## Usage

``` r
define_wasting(
  df,
  zscores = NULL,
  muac = NULL,
  oedema = NULL,
  .by = c("zscores", "muac", "combined")
)
```

## Arguments

- df:

  A `tibble` object. It must have been wrangled using this package's
  wrangling functions for WFHZ or MUAC, or both (for combined) as
  appropriate.

- zscores:

  A vector of class `double` of WFHZ or MFAZ values.

- muac:

  An `integer` or `character` vector of raw MUAC values in millimetres.

- oedema:

  A `character` vector indicating oedema status. Default is NULL. Code
  values should be "y" for presence and "n" for absence of nutritional
  oedema.

- .by:

  A choice of the criterion by which a case is to be defined. Choose
  "zscores" for WFHZ or MFAZ, "muac" for raw MUAC and "combined" for
  combined. Default value is "zscores".

## Value

The `tibble` object `df` with additional columns named named `gam`,
`sam` and `mam`, each of class `numeric` containing coded values of
either 1 (case) and 0 (not a case). If `.by = "combined"`, additional
columns are named `cgam`, `csam` and `cmam`.

## Examples

``` r
## Case-definition by z-scores ----
z <- anthro.02 |>
  define_wasting(
    zscores = wfhz,
    muac = NULL,
    oedema = oedema,
    .by = "zscores"
  )
head(z)
#> # A tibble: 6 × 17
#>   province strata cluster   sex   age weight height oedema  muac wtfactor   wfhz
#>   <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>  <dbl>
#> 1 Zambezia Rural      391     1  6.01    8.2   68   n        152     825.  0.349
#> 2 Zambezia Rural      404     2  6.01    7.1   65.1 n        139     287. -0.006
#> 3 Zambezia Rural      399     1  6.11    7.6   64.1 n        155     130.  0.9  
#> 4 Zambezia Urban      430     2  6.14    7.9   65.9 n        148    1277.  0.876
#> 5 Zambezia Urban      468     2  6.28    6.6   59.7 n        132     792.  1.38 
#> 6 Zambezia Urban      517     2  6.34    6     61.8 n        129     480. -0.583
#> # ℹ 6 more variables: flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>, gam <dbl>,
#> #   sam <dbl>, mam <dbl>

## Case-definition by MUAC ----
m <- anthro.02 |>
  define_wasting(
    zscores = NULL,
    muac = muac,
    oedema = oedema,
    .by = "muac"
  )
head(m)
#> # A tibble: 6 × 17
#>   province strata cluster   sex   age weight height oedema  muac wtfactor   wfhz
#>   <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>  <dbl>
#> 1 Zambezia Rural      391     1  6.01    8.2   68   n        152     825.  0.349
#> 2 Zambezia Rural      404     2  6.01    7.1   65.1 n        139     287. -0.006
#> 3 Zambezia Rural      399     1  6.11    7.6   64.1 n        155     130.  0.9  
#> 4 Zambezia Urban      430     2  6.14    7.9   65.9 n        148    1277.  0.876
#> 5 Zambezia Urban      468     2  6.28    6.6   59.7 n        132     792.  1.38 
#> 6 Zambezia Urban      517     2  6.34    6     61.8 n        129     480. -0.583
#> # ℹ 6 more variables: flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>, gam <dbl>,
#> #   sam <dbl>, mam <dbl>

## Case-definition by combined ----
c <- anthro.02 |>
  define_wasting(
    zscores = wfhz,
    muac = muac,
    oedema = oedema,
    .by = "combined"
  )
head(c)
#> # A tibble: 6 × 17
#>   province strata cluster   sex   age weight height oedema  muac wtfactor   wfhz
#>   <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>  <dbl>
#> 1 Zambezia Rural      391     1  6.01    8.2   68   n        152     825.  0.349
#> 2 Zambezia Rural      404     2  6.01    7.1   65.1 n        139     287. -0.006
#> 3 Zambezia Rural      399     1  6.11    7.6   64.1 n        155     130.  0.9  
#> 4 Zambezia Urban      430     2  6.14    7.9   65.9 n        148    1277.  0.876
#> 5 Zambezia Urban      468     2  6.28    6.6   59.7 n        132     792.  1.38 
#> 6 Zambezia Urban      517     2  6.34    6     61.8 n        129     480. -0.583
#> # ℹ 6 more variables: flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>, cgam <dbl>,
#> #   csam <dbl>, cmam <dbl>
```

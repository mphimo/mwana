# Estimate the prevalence of wasting based on weight-for-height z-scores (WFHZ)

Calculate the prevalence estimates of wasting based on z-scores of
weight-for-height and/or nutritional oedema. The function allows users
to estimate prevalence in accordance with complex sample design
properties such as accounting for survey sample weights when needed or
applicable. The quality of the data is first evaluated by calculating
and rating the standard deviation of WFHZ. Standard approach to
prevalence estimation is calculated only when the standard deviation of
MFAZ is rated as not problematic. If the standard deviation is
problematic, prevalence is estimated using the PROBIT estimator.
Outliers are detected based on SMART flagging criteria. Identified
outliers are then excluded before prevalence estimation is performed.

## Usage

``` r
mw_estimate_prevalence_wfhz(df, wt = NULL, oedema = NULL, ...)
```

## Arguments

- df:

  A `tibble` object that has been produced by the
  [`mw_wrangle_wfhz()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_wfhz.md)
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
## When .by = NULL ----
### Start off by wrangling the data ----
data <- mw_wrangle_wfhz(
  df = anthro.03,
  sex = sex,
  weight = weight,
  height = height,
  .recode_sex = TRUE
)
#> ================================================================================

### Now run the prevalence function ----
mw_estimate_prevalence_wfhz(
  df = data,
  wt = NULL,
  oedema = oedema
)
#> # A tibble: 1 × 16
#>   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low sam_p_upp
#>   <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>     <dbl>
#> 1    71 0.0768    0.0571    0.0964        Inf     9 0.00973   0.00351    0.0160
#> # ℹ 7 more variables: sam_p_deff <dbl>, mam_n <dbl>, mam_p <dbl>,
#> #   mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>, wt_pop <dbl>

## Now when .by is not set to NULL ----
mw_estimate_prevalence_wfhz(
  df = data,
  wt = NULL,
  oedema = oedema,
  district
)
#> # A tibble: 4 × 17
#>   district   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low
#>   <chr>      <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>
#> 1 Cahora-Ba…    22 0.0738    0.0348    0.113         Inf     1 0.00336  -0.00348
#> 2 Chiuta        10 0.0444    0.0129    0.0759        Inf     1 0.00444  -0.00466
#> 3 Maravia       NA 0.0450   NA        NA              NA    NA 0.00351  NA      
#> 4 Metuge        NA 0.0251   NA        NA              NA    NA 0.00155  NA      
#> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
#> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
#> #   wt_pop <dbl>

## When a weighted analysis is needed ----
mw_estimate_prevalence_wfhz(
  df = anthro.02,
  wt = wtfactor,
  oedema = oedema,
  province
)
#> # A tibble: 2 × 17
#>   province gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n   sam_p sam_p_low
#>   <chr>    <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>   <dbl>     <dbl>
#> 1 Nampula     53 0.0595    0.0410    0.0779       1.52    10 0.0129   0.00272 
#> 2 Zambezia    33 0.0261    0.0161    0.0361       1.16     4 0.00236 -0.000255
#> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
#> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
#> #   wt_pop <dbl>
```

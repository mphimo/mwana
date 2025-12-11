# Estimate the prevalence of wasting based on MUAC for survey data

Estimate the prevalence of wasting based on MUAC and/or nutritional
oedema. The function allows users to estimate prevalence in accordance
with complex sample design properties, such as accounting for survey
sample weights when needed or applicable.

The quality of the data is first evaluated by calculating and rating the
standard deviation (SD) of MFAZ and the p-value of the age ratio test.
Thereafter, if the latter test is problematic, age-weighting approach is
applied to prevalence estimation, to account for the over-representation
of younger children in the sample; otherwise, a non-age-weighted
prevalence is estimated. This means that even if the SD of MFAZ is
problematic, the prevalence is estimated, with no adjustments, and
returned.

## Usage

``` r
mw_estimate_prevalence_muac(df, wt = NULL, oedema = NULL, ...)
```

## Arguments

- df:

  A `tibble` object produced by
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
  and
  [`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
  functions. Note that MUAC values in `df` must be in millimetres after
  using
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md).
  Also, `df` must have a variable called `cluster` wherein the primary
  sampling unit identifiers are stored.

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

[`mw_estimate_age_weighted_prev_muac()`](https://mphimo.github.io/mwana/reference/mw_estimate_age_weighted_prev_muac.md)
[`mw_estimate_prevalence_mfaz()`](https://mphimo.github.io/mwana/reference/mw_estimate_prevalence_mfaz.md)
[`mw_estimate_prevalence_screening()`](https://mphimo.github.io/mwana/reference/muac-screening.md)

## Examples

``` r
## Ungrouped analysis ----
mw_estimate_prevalence_muac(
  df = anthro.04,
  wt = NULL,
  oedema = oedema
)
#> # A tibble: 1 × 3
#>    sam_p  mam_p  gam_p
#>    <dbl>  <dbl>  <dbl>
#> 1 0.0164 0.0783 0.0947

## Grouped analysis ----
mw_estimate_prevalence_muac(
  df = anthro.04,
  wt = NULL,
  oedema = oedema,
  province
)
#> # A tibble: 3 × 17
#>   province   gam_n  gam_p gam_p_low gam_p_upp gam_p_deff sam_n  sam_p sam_p_low
#>   <chr>      <dbl>  <dbl>     <dbl>     <dbl>      <dbl> <dbl>  <dbl>     <dbl>
#> 1 Province 1   133 0.104     0.0778     0.130        Inf    17 0.0133   0.00682
#> 2 Province 2    NA 0.0858   NA         NA             NA    NA 0.0148  NA      
#> 3 Province 3    87 0.145     0.0930     0.196        Inf    25 0.0416   0.0176 
#> # ℹ 8 more variables: sam_p_upp <dbl>, sam_p_deff <dbl>, mam_n <dbl>,
#> #   mam_p <dbl>, mam_p_low <dbl>, mam_p_upp <dbl>, mam_p_deff <dbl>,
#> #   wt_pop <dbl>

```

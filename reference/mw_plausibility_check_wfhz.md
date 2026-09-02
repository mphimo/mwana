# Check the plausibility and acceptability of weight-for-height z-score (WFHZ) data

Check the overall plausibility and acceptability of WFHZ data through a
structured test suite encompassing checks for sampling and
measurement-related biases in the dataset. The test suite, including the
criteria and corresponding rating of acceptability, follows the
standards in the SMART plausibility check.

The function works on a data frame returned by this package's wrangling
functions for age and for WFHZ data.

## Usage

``` r
mw_plausibility_check_wfhz(df, sex, age, weight, height, flags, ...)
```

## Arguments

- df:

  A `tibble` object to check.

- sex:

  A `numeric` vector for child's sex with 1 = males and 2 = females.

- age:

  A vector of class `double` of child's age in months.

- weight:

  A vector of class `double` of child's weight in kilograms.

- height:

  A vector of class `double` of child's height in centimetres.

- flags:

  A `numeric` vector of flagged records.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A single-row summary `tibble` with columns containing the plausibility
check results. If ungrouped analysis, the output will consist of 19
columns and one row; otherwise, the number of columns will vary
according to the number vectors specified, and the number of rows to the
categories within the grouping variables.

## References

SMART Initiative (2017). *Standardized Monitoring and Assessment for
Relief and Transition*. Manual 2.0. Available at:
<https://smartmethodology.org>.

## See also

[`mw_plausibility_check_mfaz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_mfaz.md)
[`mw_plausibility_check_muac()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_muac.md)
[`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)

## Examples

``` r
## First wrangle age data ----
data <- mw_wrangle_age(
  df = anthro.01,
  dos = dos,
  dob = dob,
  age = age,
  .decimals = 2
)

## Then wrangle WFHZ data ----
data_wfhz <- mw_wrangle_wfhz(
  df = data,
  sex = sex,
  weight = weight,
  height = height,
  .recode_sex = TRUE
)
#> ================================================================================

## Now run the plausibility check ----
mw_plausibility_check_wfhz(
  df = data_wfhz,
  sex = sex,
  age = age,
  weight = weight,
  height = height,
  flags = flag_wfhz,
  area, team
)
#> # A tibble: 8 × 21
#> # Groups:   area, team [8]
#>   area      team     n flagged flagged_class sex_ratio sex_ratio_class age_ratio
#>   <chr>    <int> <int>   <dbl> <fct>             <dbl> <chr>               <dbl>
#> 1 Distric…     1   120  0      Excellent         0.784 Excellent           0.125
#> 2 Distric…     2   216  0.0139 Excellent         0.838 Excellent           0.919
#> 3 Distric…     3   104  0      Excellent         0.281 Excellent           1    
#> 4 Distric…     4    65  0.0154 Excellent         0.457 Excellent           0.249
#> 5 Distric…     1   200  0      Excellent         0.724 Excellent           0.183
#> 6 Distric…     6   140  0.0143 Excellent         0.447 Excellent           1    
#> 7 Distric…     7   188  0.0160 Excellent         0.512 Excellent           0.552
#> 8 Distric…    10   158  0.0190 Excellent         0.474 Excellent           0.270
#> # ℹ 13 more variables: age_ratio_class <chr>, dps_wgt <dbl>,
#> #   dps_wgt_class <chr>, dps_hgt <dbl>, dps_hgt_class <chr>, sd <dbl>,
#> #   sd_class <chr>, skew <dbl>, skew_class <fct>, kurt <dbl>, kurt_class <fct>,
#> #   quality_score <dbl>, quality_class <fct>
```

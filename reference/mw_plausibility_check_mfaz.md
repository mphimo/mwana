# Check the plausibility and acceptability of MUAC-for-age z-score (MFAZ) data

Check the overall plausibility and acceptability of MFAZ data through a
structured test suite encompassing checks for sampling and
measurement-related biases in the dataset. This test suite follows the
recommendation made by Bilukha & Kianian (2023) on the plausibility of
constructing a comprehensive plausibility check for MUAC data similar to
weight-for-height z-score to evaluate its acceptability when age values
are available in the dataset.

The function works on a `data.frame` returned from wrangling functions
for age and for MUAC-for-age z-score data available from this package.

## Usage

``` r
mw_plausibility_check_mfaz(df, sex, muac, age, flags, ...)
```

## Arguments

- df:

  A `data.frame` object to check.

- sex:

  A `numeric` vector for child's sex with 1 = males and 2 = females.

- muac:

  A `numeric` vector of child's MUAC in centimetres.

- age:

  A vector of class `double` of child's age in months.

- flags:

  A `numeric` vector of flagged records.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A single-row summary `tibble` with columns containing the plausibility
check results. If ungrouped analysis, the output will consist of 17
columns and one row; otherwise, the number of columns will vary
according to the number vectors specified, and the number of rows to the
categories within the grouping variables.

## Details

Whilst the function uses the same checks and criteria as those for
weight-for-height z-scores in the SMART plausibility check, the percent
of flagged records is evaluated using different cut-off points, with a
maximum acceptability of 2.0% as shown below:

|               |             |                |                 |
|---------------|-------------|----------------|-----------------|
| **Excellent** | **Good**    | **Acceptable** | **Problematic** |
| 0.0 - 1.0     | \>1.0 - 1.5 | \>1.5 - 2.0    | \>2.0           |

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

[`mw_wrangle_age()`](https://mphimo.github.io/mwana/reference/mw_wrangle_age.md)
[`mw_wrangle_muac()`](https://mphimo.github.io/mwana/reference/mw_wrangle_muac.md)
[`mw_stattest_ageratio()`](https://mphimo.github.io/mwana/reference/age_ratio.md)
[`flag_outliers()`](https://mphimo.github.io/mwana/reference/outliers.md)

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

## Then wrangle MUAC data ----
data_muac <- mw_wrangle_muac(
  df = data,
  sex = sex,
  age = age,
  muac = muac,
  .recode_sex = TRUE,
  .recode_muac = TRUE,
  .to = "cm"
)
#> ================================================================================

## And finally run plausibility check ----
mw_plausibility_check_mfaz(
  df = data_muac,
  flags = flag_mfaz,
  sex = sex,
  muac = muac,
  age = age,
  area, team
)
#> # A tibble: 8 × 19
#> # Groups:   area, team [8]
#>   area      team     n flagged flagged_class sex_ratio sex_ratio_class age_ratio
#>   <chr>    <int> <int>   <dbl> <fct>             <dbl> <chr>               <dbl>
#> 1 Distric…     1   120 0       Excellent         0.784 Excellent          0.0762
#> 2 Distric…     2   216 0       Excellent         0.838 Excellent          0.713 
#> 3 Distric…     3   104 0       Excellent         0.281 Excellent          0.585 
#> 4 Distric…     4    65 0       Excellent         0.457 Excellent          0.619 
#> 5 Distric…     1   200 0       Excellent         0.724 Excellent          0.296 
#> 6 Distric…     6   140 0.00714 Excellent         0.447 Excellent          0.0586
#> 7 Distric…     7   188 0.0160  Acceptable        0.512 Excellent          0.561 
#> 8 Distric…    10   158 0.0127  Good              0.474 Excellent          0.375 
#> # ℹ 11 more variables: age_ratio_class <chr>, dps <dbl>, dps_class <chr>,
#> #   sd <dbl>, sd_class <chr>, skew <dbl>, skew_class <fct>, kurt <dbl>,
#> #   kurt_class <fct>, quality_score <dbl>, quality_class <fct>
```

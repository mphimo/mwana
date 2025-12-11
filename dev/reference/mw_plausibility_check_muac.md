# Check the plausibility and acceptability of raw MUAC data

Check the overall plausibility and acceptability of raw MUAC data
through a structured test suite encompassing checks for sampling and
measurement-related biases in the dataset. The test suite in this
function follows the recommendation made by Bilukha & Kianian (2023).

## Usage

``` r
mw_plausibility_check_muac(df, sex, muac, flags, ...)
```

## Arguments

- df:

  A `data.frame` object to check. It must have been wrangled using the
  [`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_muac.md)
  function.

- sex:

  A `numeric` vector for child's sex with 1 = males and 2 = females.

- muac:

  A vector of class `double` of child's MUAC in centimetres.

- flags:

  A `numeric` vector of flagged records.

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A single-row summary `tibble` with columns containing the plausibility
check results. If ungrouped analysis, the output will consist of nine
columns and one row; otherwise, the number of columns will vary
according to the number vectors specified, and the number of rows to the
categories within the grouping variables.

## Details

Cut-off points used for the percent of flagged records:

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

[`mw_wrangle_muac()`](https://mphimo.github.io/mwana/dev/reference/mw_wrangle_muac.md)
[`flag_outliers()`](https://mphimo.github.io/mwana/dev/reference/outliers.md)

## Examples

``` r
## First wrangle MUAC data ----
df_muac <- mw_wrangle_muac(
  df = anthro.01,
  sex = sex,
  muac = muac,
  age = NULL,
  .recode_sex = TRUE,
  .recode_muac = FALSE,
  .to = "none"
)

## Then run the plausibility check ----
mw_plausibility_check_muac(
  df = df_muac,
  flags = flag_muac,
  sex = sex,
  muac = muac,
  area, team # group analysis by survey area and by survey team
)
#> # A tibble: 8 × 11
#> # Groups:   area, team [8]
#>   area        team     n flagged flagged_class sex_ratio sex_ratio_class   dps
#>   <chr>      <int> <int>   <dbl> <fct>             <dbl> <chr>           <dbl>
#> 1 District E     1   120  0      Excellent         0.784 Excellent        9.94
#> 2 District E     2   216  0      Excellent         0.838 Excellent        5.17
#> 3 District E     3   104  0      Excellent         0.281 Excellent        7.75
#> 4 District E     4    65  0      Excellent         0.457 Excellent       22.3 
#> 5 District G     1   200  0      Excellent         0.724 Excellent       24.4 
#> 6 District G     6   140  0      Excellent         0.447 Excellent        5.11
#> 7 District G     7   188  0.0160 Acceptable        0.512 Excellent       12.7 
#> 8 District G    10   158  0      Excellent         0.474 Excellent       12.3 
#> # ℹ 3 more variables: dps_class <chr>, sd <dbl>, sd_class <fct>
```

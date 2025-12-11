# Clean and format the output tibble returned from the MUAC plausibility check

Converts scientific notations to standard notations, rounds off values,
and renames columns to meaningful names.

## Usage

``` r
mw_neat_output_muac(df)
```

## Arguments

- df:

  A `tibble` object returned by the
  [`mw_plausibility_check_muac()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_muac.md)
  function containing the summarized results to be formatted.

## Value

A `data.frame` object of the same length and width as `df`, with column
names and values formatted for clarity and readability.

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
pl_muac <- mw_plausibility_check_muac(
  df = df_muac,
  flags = flag_muac,
  sex = sex,
  muac = muac
)

## Neat the output table ----

mw_neat_output_muac(df = pl_muac)
#> # A tibble: 1 × 9
#>   `Total children` `Flagged data (%)` `Class. of flagged data` `Sex ratio (p)`
#>              <int> <chr>              <fct>                    <chr>          
#> 1             1191 0.3%               Excellent                0.297          
#> # ℹ 5 more variables: `Class. of sex ratio` <chr>, `DPS(#)` <dbl>,
#> #   `Class. of DPS` <chr>, `Standard Dev* (#)` <dbl>,
#> #   `Class. of standard dev` <fct>
```

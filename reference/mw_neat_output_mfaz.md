# Clean and format the output tibble returned from the MUAC-for-age z-score plausibility check

Converts scientific notations to standard notations, rounds off values,
and renames columns to meaningful names.

## Usage

``` r
mw_neat_output_mfaz(df)
```

## Arguments

- df:

  An `data.frame` object returned by
  [`mw_plausibility_check_mfaz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_mfaz.md)
  containing the summarized results to be formatted.

## Value

A `data.frame` object of the same length and width as `df`, with column
names and values formatted as appropriate.

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
data_mfaz <- mw_wrangle_muac(
  df = data,
  sex = sex,
  age = age,
  muac = muac,
  .recode_sex = TRUE,
  .recode_muac = TRUE,
  .to = "cm"
)
#> ================================================================================

## Then run plausibility check ----
pl <- mw_plausibility_check_mfaz(
  df = data_mfaz,
  flags = flag_mfaz,
  sex = sex,
  muac = muac,
  age = age,
  area
)

## Now neat the output table ----
mw_neat_output_mfaz(df = pl)
#> # A tibble: 2 × 18
#> # Groups:   Area [2]
#>   Area       `Total children` `Flagged data (%)` `Class. of flagged data`
#>   <chr>                 <int> <chr>              <fct>                   
#> 1 District E              505 0.0%               Excellent               
#> 2 District G              686 0.9%               Excellent               
#> # ℹ 14 more variables: `Sex ratio (p)` <chr>, `Class. of sex ratio` <chr>,
#> #   `Age ratio (p)` <chr>, `Class. of age ratio` <chr>, `DPS (#)` <dbl>,
#> #   `Class. of DPS` <chr>, `Standard Dev* (#)` <dbl>,
#> #   `Class. of standard dev` <chr>, `Skewness* (#)` <dbl>,
#> #   `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
#> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, `Overall quality` <fct>
```

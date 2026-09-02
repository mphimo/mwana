# Clean and format the output tibble returned from the WFHZ plausibility check

Converts scientific notations to standard notations, rounds off values,
and renames columns to meaningful names.

## Usage

``` r
mw_neat_output_wfhz(df)
```

## Arguments

- df:

  An `tibble` object returned by the
  [`mw_plausibility_check_wfhz()`](https://mphimo.github.io/mwana/reference/mw_plausibility_check_wfhz.md)
  containing the summarized results to be formatted.

## Value

A `tibble` object of the same length and width as `df`, with column
names and values formatted for clarity and readability.

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
pl <- mw_plausibility_check_wfhz(
  df = data_wfhz,
  sex = sex,
  age = age,
  weight = weight,
  height = height,
  flags = flag_wfhz,
  area
)

## Now neat the output table ----
mw_neat_output_wfhz(df = pl)
#> # A tibble: 2 × 20
#> # Groups:   Area [2]
#>   Area       `Total children` `Flagged data (%)` `Class. of flagged data`
#>   <chr>                 <int> <chr>              <fct>                   
#> 1 District E              505 0.8%               Excellent               
#> 2 District G              686 1.2%               Excellent               
#> # ℹ 16 more variables: `Sex ratio (p)` <chr>, `Class. of sex ratio` <chr>,
#> #   `Age ratio (p)` <chr>, `Class. of age ratio` <chr>, `DPS weight (#)` <dbl>,
#> #   `Class. DPS weight` <chr>, `DPS height (#)` <dbl>,
#> #   `Class. DPS height` <chr>, `Standard Dev* (#)` <dbl>,
#> #   `Class. of standard dev` <chr>, `Skewness* (#)` <dbl>,
#> #   `Class. of skewness` <fct>, `Kurtosis* (#)` <dbl>,
#> #   `Class. of kurtosis` <fct>, `Overall score` <dbl>, …
```

# Wrangle child's age

Wrangle child's age for downstream analysis. This includes calculating
age in months based on the date of data collection and the child's date
of birth, and setting to NA the age values that are less than 6.0 and
greater than or equal to 60.0 months old.

## Usage

``` r
mw_wrangle_age(df, dos = NULL, dob = NULL, age, .decimals = 2)
```

## Arguments

- df:

  A `data.frame` object to wrangle age from.

- dos:

  A `Date` vector of dates when data collection was conducted. Default
  is NULL.

- dob:

  A `Date` vector of dates of birth of child. Default is NULL.

- age:

  A `numeric` vector of child's age in months. In most cases this will
  be estimated using local event calendars or calculated age in months
  based on date of data collection and date of birth of child.

- .decimals:

  The number of decimal places to round off age to. Default is 2.

## Value

A `tibble` based on `df`. The variable `age` will be automatically
filled in each row where age value was missing and both the child's date
of birth and the date of data collection are available. Rows where `age`
is less than 6.0 and greater than or equal to 60.0 months old will be
set to NA. Additionally, a new variable named `age_days` of class
`double` for calculated age of child in days is added to `df`.

## Examples

``` r
## A sample data ----
df <- data.frame(
  surv_date = as.Date(c(
    "2023-01-01", "2023-01-01", "2023-01-01", "2023-01-01", "2023-01-01"
  )),
  birth_date = as.Date(c(
    "2019-01-01", NA, "2018-03-20", "2019-11-05", "2021-04-25"
  )),
  age = c(NA, 36, NA, NA, NA)
)

## Apply the function ----
mw_wrangle_age(
  df = df,
  dos = surv_date,
  dob = birth_date,
  age = age,
  .decimals = 3
)
#> # A tibble: 5 × 4
#>   surv_date  birth_date   age age_days
#>   <date>     <date>     <dbl>    <dbl>
#> 1 2023-01-01 2019-01-01  48      1461 
#> 2 2023-01-01 NA          36      1096.
#> 3 2023-01-01 2018-03-20  57.4    1748 
#> 4 2023-01-01 2019-11-05  37.9    1153 
#> 5 2023-01-01 2021-04-25  20.2     616 
```

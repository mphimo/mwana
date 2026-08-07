# Calculate child's age in months

Calculate child's age in months based on the date of birth and the date
of data collection.

## Usage

``` r
get_age_months(dos, dob)
```

## Arguments

- dos:

  A `Date` vector of date of data collection.

- dob:

  A `Date` vector of the child's date of birth.

## Value

A `numeric` vector of child's age in months. Any value less than 6.0 and
greater than or equal to 60.0 months are set to NA.

## Examples

``` r
## Take two vectors of class "Date" ----
surv_date <- as.Date(
  c(
    "2024-01-05", "2024-01-05", "2024-01-05", "2024-01-08", "2024-01-08",
    "2024-01-08", "2024-01-10", "2024-01-10", "2024-01-10", "2024-01-11"
  )
)
bir_date <- as.Date(
  c(
    "2022-04-04", "2021-05-01", "2023-05-24", "2017-12-12", NA,
    "2020-12-12", "2022-04-04", "2021-05-01", "2023-05-24", "2020-12-12"
  )
)

## Apply the function ----
get_age_months(
  dos = surv_date,
  dob = bir_date
)
#>  [1] 21.059548 32.164271  7.425051        NA        NA 36.862423 21.223819
#>  [8] 32.328542  7.589322 36.960986
```

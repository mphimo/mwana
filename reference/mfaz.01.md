# A sample mid-upper arm circumference (MUAC) screening data

A sample mid-upper arm circumference (MUAC) screening data

## Usage

``` r
mfaz.01
```

## Format

A tibble with 661 rows and 4 columns.

|              |                                                  |
|--------------|--------------------------------------------------|
| **Variable** | **Description**                                  |
| *sex*        | Sex; "m" = boys, "f" = girls                     |
| *months*     | Calculated age in months with two decimal places |
| *oedema*     | oedema, "n" = no oedema, "y" = with oedema       |
| *muac*       | Mid-upper arm circumference in millimetres       |

## Source

Anonymous

## Examples

``` r
mfaz.01
#> # A tibble: 667 × 7
#>      sex   age oedema  muac age_days   mfaz flag_mfaz
#>    <dbl> <dbl> <chr>  <dbl>    <dbl>  <dbl>     <dbl>
#>  1     2 20.9  n        134     636. -1.11          0
#>  2     2 24.2  n        153     736.  0.331         0
#>  3     2 26.1  n        132     795. -1.62          0
#>  4     1 43.9  n        144    1335. -1.32          0
#>  5     2 25.7  n        150     782  -0.007         0
#>  6     2 39.8  n        174    1210.  1.10          0
#>  7     1 47.9  n        156    1459. -0.412         0
#>  8     2  8.08 n        125     246. -1.37          0
#>  9     2 39.8  n        146    1213. -0.966         0
#> 10     1 47.6  n        150    1450. -0.887         0
#> # ℹ 657 more rows
```

# A sample SMART survey data with weight-for-height z-score standard deviation rated as problematic

A sample SMART survey data with weight-for-height z-score standard
deviation rated as problematic

## Usage

``` r
wfhz.01
```

## Format

A tibble with 303 rows and 6 columns.

|              |                                                                       |
|--------------|-----------------------------------------------------------------------|
| **Variable** | **Description**                                                       |
| *cluster*    | Primary sampling unit                                                 |
| *sex*        | Sex; "m" = boys, "f" = girls                                          |
| *age*        | Calculated age in months with two decimal places                      |
| *oedema*     | oedema, "n" = no oedema, "y" = with oedema                            |
| *wfhz*       | MUAC-for-age z-scores with 3 decimal places                           |
| *flag_wfhz*  | Flagged weight-for-height z-score value; 1 = flagged, 0 = not flagged |

## Source

Anonymous

## Examples

``` r
wfhz.01
#> # A tibble: 303 × 6
#>    cluster   sex   age oedema   wfhz flag_wfhz
#>      <int> <dbl> <dbl> <chr>   <dbl>     <dbl>
#>  1       1     1  30.1 n       1.83          0
#>  2      11     2   8.8 n       0.278         0
#>  3      11     2  43.4 n      -0.123         0
#>  4      11     2  39.1 n       1.44          0
#>  5       1     1  51.0 n       0.652         0
#>  6       1     2  28.6 n       0.469         0
#>  7       1     2  18.8 n       0.886         0
#>  8       1     1  55   n      -0.701         0
#>  9       1     2  20.3 n       0.232         0
#> 10       3     2  58.0 n      -0.384         0
#> # ℹ 293 more rows

```

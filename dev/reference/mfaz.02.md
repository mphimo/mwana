# A sample SMART survey data with mid-upper arm circumference measurements

A sample SMART survey data with mid-upper arm circumference measurements

## Usage

``` r
mfaz.02
```

## Format

A tibble with 303 rows and 7 columns.

|              |                                                                  |
|--------------|------------------------------------------------------------------|
| **Variable** | **Description**                                                  |
| *cluster*    | Primary sampling unit                                            |
| *sex*        | Sex; "m" = boys, "f" = girls                                     |
| *age*        | Calculated age in months with two decimal places                 |
| *oedema*     | oedema, "n" = no oedema, "y" = with oedema                       |
| *mfaz*       | MUAC-for-age z-scores with 3 decimal places                      |
| *flag_mfaz*  | Flagged MUAC-for-age z-score value. 1 = flagged, 0 = not flagged |

## Source

Anonymous

## Examples

``` r
mfaz.02
#> # A tibble: 303 × 7
#>    cluster   sex   age oedema  muac   mfaz flag_mfaz
#>      <int> <dbl> <dbl> <chr>  <dbl>  <dbl>     <dbl>
#>  1       1     1  30.1 n        167  0.957         0
#>  2      11     2   8.8 n        145  0.373         0
#>  3      11     2  43.4 n        150 -0.764         0
#>  4      11     2  39.1 n        168  0.717         0
#>  5       1     1  51.0 n        157 -0.401         0
#>  6       1     2  28.6 n        165  0.977         0
#>  7       1     2  18.8 n        146  0.062         0
#>  8       1     1  55   n        148 -1.20          0
#>  9       1     2  20.3 n        151  0.398         0
#> 10       3     2  58.0 n        155 -0.844         0
#> # ℹ 293 more rows
```

# A sample data of district level SMART surveys conducted in Mozambique

`anthro.03` contains survey data of four districts. Each district
dataset presents distinct data quality scenarios that require a specific
prevalence analysis approach. Data from two districts have a problematic
WFHZ standard deviation. The data from the remaining two districts are
all within range.

This sample data is useful to demonstrate the use of the prevalence
functions on a multiple-domain survey data where there can be variations
in the rating of acceptability of the standard deviation, hence
requiring different analytical approach for each survey domain to ensure
accurate estimation.

## Usage

``` r
anthro.03
```

## Format

A tibble of 943 x 9.

|              |                                                  |
|--------------|--------------------------------------------------|
| **Variable** | **Description**                                  |
| *district*   | Survey location                                  |
| *cluster*    | Primary sampling unit                            |
| *team*       | Survey teams                                     |
| *sex*        | Sex; "m" = boys, "f" = girls                     |
| *age*        | Calculated age in months with two decimal places |
| *weight*     | Weight in kilograms                              |
| *height*     | Height in centimetres                            |
| *oedema*     | oedema; "n" = no oedema, "y" = with oedema       |
| *muac*       | Mid-upper arm circumference in millimetres       |

## Source

Anonymous

## Examples

``` r
anthro.03
#> # A tibble: 943 × 9
#>    district cluster  team sex     age weight height oedema  muac
#>    <chr>      <int> <int> <chr> <dbl>  <dbl>  <dbl> <chr>  <int>
#>  1 Metuge         2     2 m      9.99   10.1   69.3 n        172
#>  2 Metuge         2     2 f     43.6    10.9   91.5 n        130
#>  3 Metuge         2     2 f     32.8    11.4   91.4 n        153
#>  4 Metuge         2     2 f      7.62    8.3   69.5 n        133
#>  5 Metuge         2     2 m     28.4    10.7   82.3 n        143
#>  6 Metuge         2     2 f     12.3     6.6   69.4 n        121
#>  7 Metuge         2     2 f     32.0    11.1   85.2 n        148
#>  8 Metuge         2     2 m     34.9    12.6   86.5 n        156
#>  9 Metuge         3     3 m      9.07    8.3   71.4 n        145
#> 10 Metuge         3     3 m     45.5    11.5   85.7 n        145
#> # ℹ 933 more rows

```

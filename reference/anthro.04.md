# A sample data from a community-based sentinel site in an anonymized location

Data was collected from community-based sentinel sites located across
three provinces. Each provincial dataset presents distinct data quality
scenarios, requiring tailored prevalence analysis:

- *Province 1* has a MUAC-for-age z-score standard deviation and age
  ratio test rating of acceptability falling within range

- *Province 2* has age ratio rated as problematic but with an acceptable
  standard deviation of MUAC-for-age z-score

- *"Province 3* has both tests rated as problematic

This sample data is useful to demonstrate the use of the prevalence
functions on a multiple-domain survey data where variations in the
rating of acceptability of the standard deviation exist, hence require
different analytical approach for each domain to ensure accurate
estimation.

## Usage

``` r
anthro.04
```

## Format

A tibble of 3,002 x 8.

|              |                                                                  |
|--------------|------------------------------------------------------------------|
| **Variable** | **Description**                                                  |
| *province*   | Survey location                                                  |
| *cluster*    | Primary sampling unit                                            |
| *sex*        | Sex; "m" = boys, "f" = girls                                     |
| *age*        | Calculated age in months with two decimal places                 |
| *muac*       | Mid-upper arm circumference in millimetres                       |
| *oedema*     | oedema; "n" = no oedema, "y" = with oedema                       |
| *mfaz*       | MUAC-for-age z-scores with 3 decimal places                      |
| *flag_mfaz*  | Flagged MUAC-for-age z-score value; 1 = flagged, 0 = not flagged |

## Source

Anonymous

## Examples

``` r
anthro.04
#> # A tibble: 3,002 × 8
#>    province   cluster   sex   age  muac oedema   mfaz flag_mfaz
#>    <chr>        <int> <dbl> <int> <dbl> <chr>   <dbl>     <dbl>
#>  1 Province 1     298     2    24   136 n      -1.12          0
#>  2 Province 1     298     2    30   116 n      -3.44          0
#>  3 Province 1     298     2     7   140 n       0.084         0
#>  4 Province 1     298     2    18   144 n      -0.068         0
#>  5 Province 1     298     2    10   125 n      -1.48          0
#>  6 Province 1     298     2    11   125 n      -1.52          0
#>  7 Province 1     298     2    30   136 n      -1.46          0
#>  8 Province 1     298     2    24   133 n      -1.40          0
#>  9 Province 1     298     2    10   122 n      -1.78          0
#> 10 Province 1     298     2    24   142 n      -0.579         0
#> # ℹ 2,992 more rows

```

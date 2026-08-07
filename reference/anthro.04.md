# A sample data from a community-based sentinel site with location anonymised

Data herein was derived from population-based assessments in three
locations (analysis unit). Each unit presents distinct scenarios that
requires also-distinct handling during the prevalence analysis:

- *Unit A* has flawless data.

- *Unit B* has age-ratio-test results rated as problematic, with an
  observed proportion of children aged 24-59 months \< 0.66.

- *Unit C* has age-ratio-test results rated as problematic, with an
  observed proportion of children aged 24-59 months \>= 0.66.

This sample data is useful to demonstrate designed behaviours of
MUAC-prevalence functions to dealing with certain-and-expected flaws in
the data.

## Usage

``` r
anthro.04
```

## Format

A tibble of 2,192 × 6.

|                 |                                               |
|-----------------|-----------------------------------------------|
| **Variable**    | **Description**                               |
| *analysis_unit* | Location wherein the assessment was conducted |
| *cluster*       | Primary sampling unit                         |
| *sex*           | Sex; "1" = boys, "2" = girls                  |
| *age*           | Calculated age in months                      |
| *muac*          | Mid-upper arm circumference in millimetres    |
| *oedema*        | oedema; "n" = no oedema, "y" = yes oedema     |

## Source

Anonymous

## Examples

``` r
anthro.04
#> # A tibble: 2,192 × 6
#>    analysis_unit cluster   sex   age  muac oedema
#>    <chr>           <dbl> <dbl> <dbl> <dbl> <chr> 
#>  1 Unit C              8     2    50   138 n     
#>  2 Unit C              8     2    26   123 n     
#>  3 Unit C              8     2    38   131 n     
#>  4 Unit C              8     2    12   110 n     
#>  5 Unit C              8     2    36   140 n     
#>  6 Unit C              9     2    53   160 n     
#>  7 Unit C              9     1    28   125 n     
#>  8 Unit C              9     2    59   140 n     
#>  9 Unit C              9     1    29   110 n     
#> 10 Unit C              9     2    46   130 n     
#> # ℹ 2,182 more rows

```

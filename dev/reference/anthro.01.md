# A sample data of district level SMART surveys with location anonymised

`anthro.01` is a two-stage cluster-based survey with probability of
selection of clusters proportional to the size of the population. The
survey employed the SMART methodology.

## Usage

``` r
anthro.01
```

## Format

A tibble of 1,191 rows and 11 columns.

|              |                                                                |
|--------------|----------------------------------------------------------------|
| **Variable** | **Description**                                                |
| *area*       | Survey location                                                |
| *dos*        | Survey date                                                    |
| *cluster*    | Primary sampling unit                                          |
| *team*       | Enumerator IDs                                                 |
| *sex*        | Sex; "m" = boys, "f" = girls                                   |
| *dob*        | Date of birth                                                  |
| *age*        | Age in months, typically estimated using local event calendars |
| *weight*     | Weight in kilograms                                            |
| *height*     | Height in centimetres                                          |
| *oedema*     | oedema; "n" = no oedema, "y" = with oedema                     |
| *muac*       | Mid-upper arm circumference in millimetres                     |

## Source

Anonymous

## Examples

``` r
anthro.01
#> # A tibble: 1,191 × 11
#>    area     dos        cluster  team sex   dob      age weight height oedema
#>    <chr>    <date>       <int> <int> <chr> <date> <int>  <dbl>  <dbl> <chr> 
#>  1 Distric… 2023-12-04       1     3 m     NA        59   15.6  109.  n     
#>  2 Distric… 2023-12-04       1     3 m     NA         8    7.5   68.6 n     
#>  3 Distric… 2023-12-04       1     3 m     NA        19    9.7   79.5 n     
#>  4 Distric… 2023-12-04       1     3 f     NA        49   14.3  100.  n     
#>  5 Distric… 2023-12-04       1     3 f     NA        32   12.4   92.1 n     
#>  6 Distric… 2023-12-04       1     3 f     NA        17    9.3   77.8 n     
#>  7 Distric… 2023-12-04       1     3 f     NA        20   10.1   80.4 n     
#>  8 Distric… 2023-12-04       1     3 f     NA        27   11.7   87.1 n     
#>  9 Distric… 2023-12-04       1     3 m     NA        46   13.6   98   n     
#> 10 Distric… 2023-12-04       1     3 m     NA        58   17.2  109.  n     
#> # ℹ 1,181 more rows
#> # ℹ 1 more variable: muac <int>

```

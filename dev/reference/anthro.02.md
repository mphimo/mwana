# A sample of an already wrangled survey data

A household budget survey data conducted in Mozambique in 2019/2020,
known as *IOF* (*Inquérito ao Orçamento Familiar* in Portuguese). *IOF*
is a two-stage cluster-based survey, representative at province level
(second administrative level), with probability of the selection of the
clusters proportional to the size of the population. Its data collection
spans for a period of 12 months.

## Usage

``` r
anthro.02
```

## Format

A tibble of 2,267 rows and 14 columns.

|              |                                                          |
|--------------|----------------------------------------------------------|
| **Variable** | **Description**                                          |
| *province*   | The administrative unit level 1 where data was collected |
| *strata*     | Rural or Urban                                           |
| *cluster*    | Primary sampling unit                                    |
| *sex*        | Sex; "m" = boys, "f" = girls                             |
| *age*        | Calculated age in months with two decimal places         |
| *weight*     | Weight in kilograms                                      |
| *height*     | Height in centimetres                                    |
| *oedema*     | oedema; "n" = no oedema, "y" = with oedema               |
| *muac*       | Mid-upper arm circumference in millimetres               |
| *wtfactor*   | Survey weights                                           |
| *wfhz*       | Weight-for-height z-scores with 3 decimal places         |
| *flag_wfhz*  | Flagged WFHZ value. 1 = flagged, 0 = not flagged         |
| *mfaz*       | MUAC-for-age z-scores with 3 decimal places              |
| *flag_mfaz*  | Flagged MFAZ value. 1 = flagged, 0 = not flagged         |

## Source

Mozambique National Institute of Statistics. The data is publicly
available at
<https://mozdata.ine.gov.mz/index.php/catalog/88#metadata-data_access>.
Data was wrangled using this package's wranglers. Details about survey
design can be read from:
<https://mozdata.ine.gov.mz/index.php/catalog/88#metadata-sampling>

## Examples

``` r
anthro.02
#> # A tibble: 2,267 × 14
#>    province strata cluster   sex   age weight height oedema  muac wtfactor
#>    <chr>    <chr>    <int> <dbl> <dbl>  <dbl>  <dbl> <chr>  <dbl>    <dbl>
#>  1 Zambezia Rural      391     1  6.01    8.2   68   n        152     825.
#>  2 Zambezia Rural      404     2  6.01    7.1   65.1 n        139     287.
#>  3 Zambezia Rural      399     1  6.11    7.6   64.1 n        155     130.
#>  4 Zambezia Urban      430     2  6.14    7.9   65.9 n        148    1277.
#>  5 Zambezia Urban      468     2  6.28    6.6   59.7 n        132     792.
#>  6 Zambezia Urban      517     2  6.34    6     61.8 n        129     480.
#>  7 Zambezia Urban      461     2  6.34    6.5   64.4 n        123     977.
#>  8 Zambezia Rural      382     2  6.41    6.5   63.4 n        126     165.
#>  9 Zambezia Urban      502     1  6.41    7.5   66   n        142    1083.
#> 10 Zambezia Urban      500     1  6.41    6.8   64.1 n        135     972.
#> # ℹ 2,257 more rows
#> # ℹ 4 more variables: wfhz <dbl>, flag_wfhz <dbl>, mfaz <dbl>, flag_mfaz <dbl>
```

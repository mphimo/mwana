# Check whether sample size requirements for IPC Acute Malnutrition (IPC AMN) analysis are met

Data for estimating the prevalence of acute malnutrition used in the IPC
AMN can come from different sources: surveys, screenings or
community-based surveillance systems. The IPC has set minimum sample
size requirements for each source. This function verifies whether these
requirements are met.

## Usage

``` r
mw_check_ipcamn_ssreq(
  df,
  cluster,
  .source = c("survey", "screening", "ssite"),
  ...
)
```

## Arguments

- df:

  A `data.frame` object to check.

- cluster:

  A vector of class `integer` or `character` of unique cluster or
  screening or sentinel site identifiers. If a `character` vector,
  ensure that each unique name represents one location. If `cluster` is
  not of class `integer` or `character`, an error message will be
  returned indicating the type of mismatch.

- .source:

  The source of evidence. A choice between "survey" for representative
  survey data at the area of analysis; "screening" for screening data;
  "ssite" for community-based sentinel site data. Default value is
  "survey".

- ...:

  A vector of class `character`, specifying the categories for which the
  analysis should be summarised for. Usually geographical areas. More
  than one vector can be specified.

## Value

A summary `tibble` containing check results for:

- `n_clusters` - the total number of unique clusters or screening or
  site identifiers;

- `n_obs` - the corresponding total number of children in the dataset;
  and,

- `meet_ipc` - whether the IPC AMN requirements were met.

## References

IPC Global Partners. 2021. *Integrated Food Security Phase
Classification* *Technical Manual Version 3.1.Evidence and Standards for
Better Food Security* *and Nutrition Decisions*. Rome. Available at:
<https://www.ipcinfo.org/ipcinfo-website/resources/ipc-manual/en/>.

## Examples

``` r
mw_check_ipcamn_ssreq(
  df = anthro.01,
  cluster = cluster,
  .source = "survey",
  area
)
#> # A tibble: 2 × 4
#>   area       n_clusters n_obs meet_ipc
#>   <chr>           <int> <int> <chr>   
#> 1 District E         28   505 yes     
#> 2 District G         30   686 yes     
```

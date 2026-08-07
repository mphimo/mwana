# Get the overall acceptability score from the acceptability rate scores

Get the overall acceptability score from the acceptability rate scores

## Usage

``` r
score_overall_quality(
  cl_flags,
  cl_sex,
  cl_age,
  cl_dps_m = NULL,
  cl_dps_w = NULL,
  cl_dps_h = NULL,
  cl_std,
  cl_skw,
  cl_kurt,
  .for = c("wfhz", "mfaz")
)
```

## Arguments

- .for:

  A choice between "wfhz" and "mfaz" for the type of scorer to apply.
  Default is "wfhz".

## Value

A `numeric` value for the overall data quality (acceptability) score.

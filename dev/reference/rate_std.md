# Rate the acceptability of the standard deviation

Rate the acceptability of the standard deviation of WFHZ, MFAZ, and raw
MUAC data. Rating follows the SMART methodology criteria.

## Usage

``` r
rate_std(sd, .of = c("zscores", "raw_muac"))
```

## Arguments

- sd:

  A vector of class `double` of standard deviation values from the
  dataset.

- .of:

  Specifies the dataset to which the rating should be done. Can be
  "wfhz", "mfaz", or "raw_muac".

## Value

A vector of class `factor` of the same length as `sd` for the
acceptability rate.

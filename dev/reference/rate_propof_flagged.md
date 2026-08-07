# Rate the acceptability of the proportion of flagged records

Rate the acceptability of the proportion of flagged records in WFHZ,
MFAZ, and raw MUAC data following the SMART methodology criteria.

## Usage

``` r
rate_propof_flagged(p, .in = c("mfaz", "wfhz", "raw_muac"))
```

## Arguments

- p:

  A vector of class `double` of the proportions of flagged records in
  the dataset.

- .in:

  Specifies the dataset where the rating should be done. Can be "wfhz",
  "mfaz", or "raw_muac". Default to "wfhz".

## Value

A vector of class `factor` with the same length as `p` for the
acceptability rate.

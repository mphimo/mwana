# Convert MUAC values to either centimetres or millimetres

Convert MUAC values to either centimetres or millimetres

## Usage

``` r
recode_muac(x, .to = c("cm", "mm"))
```

## Arguments

- x:

  A vector of raw MUAC values. The class can either be `double` or
  `numeric` or `integer`.

- .to:

  Either "cm" (centimetres) or "mm" (millimetres) for the unit of
  measurement to convert MUAC values to.

## Value

A `numeric` vector of the same length as `x` with values set to
specified unit of measurement.

## Examples

``` r
## Recode from millimetres to centimetres ----
muac_cm <- recode_muac(
  x = anthro.01$muac,
  .to = "cm"
)
head(muac_cm)
#> [1] 14.6 12.7 14.2 14.9 14.3 13.2

## Using the `muac_cm` object to recode it back to "mm" ----
muac_mm <- recode_muac(
  x = muac_cm,
  .to = "mm"
)
tail(muac_mm)
#> [1] 149 149 168 168 152 140
```

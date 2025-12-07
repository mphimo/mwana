# Test check: smart_age_weighting() ----
## oedema set to !NULL ----
testthat::test_that(
  "mw_estimate_age_weighted_prev_muac() works as expected",
  {
    ### Input data ----
    x <- mfaz.01 |>
      mw_wrangle_age(
        age = age
      ) |>
      mw_wrangle_muac(
        sex = sex,
        muac = muac,
        age = age,
        .recode_sex = FALSE,
        .recode_muac = TRUE,
        .to = "cm"
      ) |>
      mutate(muac = recode_muac(muac, .to = "mm"))

    #### Observed results ----
    p <- mw_estimate_age_weighted_prev_muac(
      df = x, 
      muac = muac, 
      has_age = TRUE,
      age_cat = NULL,
      age = age, 
      oedema = oedema, 
      raw_muac = FALSE
    )


    ## Tests ----
    ### Under twos ----
    testthat::expect_equal(round(p$oedema_u2 * 100, 1), 1.0)
    testthat::expect_equal(round(p$u2sam * 100, 1), 3.1)
    testthat::expect_equal(round(p$u2mam * 100, 1), 16.4)
    testthat::expect_equal(round(p$u2gam * 100, 1), 20.5)

    ### Over twos ----
    testthat::expect_equal(round(p$oedema_o2 * 100, 1), 1.1)
    testthat::expect_equal(round(p$o2sam * 100, 1), 0.3)
    testthat::expect_equal(round(p$o2mam * 100, 1), 2.2)
    testthat::expect_equal(round(p$o2gam * 100, 1), 3.5)

    ### Age weighted ----
    testthat::expect_equal(round(p$sam * 100, 1), 2.3)
    testthat::expect_equal(round(p$mam * 100, 1), 6.9)
    testthat::expect_equal(round(p$gam * 100, 1), 9.2)
  }
)

# Test check: mw_estimate_age_weighted_prev_muac() ----
testthat::test_that(
  "mw_estimate_age_weighted_prev_muac() works well when `raw_muac = TRUE`",
  {
  
    ## Tests ----
    testthat::expect_error(object = anthro.04 |>
      subset(province == "Province 2") |>
      mw_estimate_age_weighted_prev_muac(raw_muac = TRUE), inherit = TRUE)

  }
)


## When MUAC is not in millimeters the function errors ----
testthat::test_that(
  "When MUAC is not in centimeters, the function stop execution",
  {
    testthat::expect_error(
      x <- anthro.01 |>
        mw_wrangle_age(
          age = age,
          .decimals = 2
        ) |>
        mw_wrangle_muac(
          sex = sex,
          muac = muac,
          age = age,
          .recode_sex = FALSE,
          .recode_muac = TRUE,
          .to = "cm",
          .decimals = 3
        ) |>
        mw_estimate_age_weighted_prev_muac(
          muac = muac,
          has_age = TRUE,
          age = age,
          oedema = oedema,
          raw_muac = FALSE
        ),
      regexp = "MUAC values must be in millimeters. Please try again."
    )
  }
)

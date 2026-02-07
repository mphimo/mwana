# ==============================================================================
# 📦 Functions: get_estimates(), mw_estimate_prevalence_screening(), and 
# mw_estimate_prevalence_screening2()
# ==============================================================================


## ---- Test check: get_estimates() --------------------------------------------


### When grouping variables are not supplied ----
testthat::test_that(
  "get_estimates() works OK",
  {
    #### Wrangle data ----
    df <- anthro.02 |>
      mutate(
        muacx = as.character(muac),
        oedemax = as.factor(oedema),
        ede = ifelse(oedema == "y", "yes", 0)
      )

    #### Get estimates ----
    p <- get_estimates(df, muac, oedema, FALSE)

    ### Observed estimates ----
    gam_n <- 118
    gam_p <- 5.4
    sam_n <- 29
    sam_p <- 1.3
    mam_n <- 89
    mam_p <- 4.1

    #### Tests ----
    testthat::expect_s3_class(p, "tbl_df")
    testthat::expect_equal(ncol(p), 7)
    testthat::expect_equal(nrow(p), 1)
    testthat::expect_true(
      all(c("gam_n", "gam_p", "sam_n", "sam_p", "mam_n", "mam_p", "N") %in% names(p))
    )
    testthat::expect_equal(p[[1]][1], gam_n)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), gam_p)
    testthat::expect_equal(p[[3]][1], sam_n)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), sam_p)
    testthat::expect_equal(p[[5]][1], mam_n)
    testthat::expect_equal(round(p[[6]][1] * 100, 1), mam_p)
    testthat::expect_error(
      anthro.02 |>
        mutate(muac = recode_muac(muac, .to = "cm")) |>
        get_estimates(muac = muac, oedema = oedema),
      regexp = "MUAC values must be in millimetres. Try again!"
    )
    testthat::expect_error(
      df |>
        get_estimates(muac = muacx, oedema = oedema
        ),
      regexp = paste0(
        "`muac` should be of class numeric not ",
        class(df$muacx), ". Try again!"
      )
    )
    testthat::expect_error(
      df |>
        get_estimates(muac = muac, oedema = oedemax
        ),
      regexp = paste0(
        "`oedema` should be of class character not ",
        class(df$oedemax), ". Try again!"
      )
    )
    testthat::expect_error(
      df |>
        get_estimates(muac = muac, oedema = ede
        ),
      regexp = 'Code values in `oedema` must only be "y" and "n". Try again!'
    )
  }
)

### When is.null(oedema) & grouping variables are not supplied ----
testthat::test_that(
  "get_estimates() works OK when oedema and grouping variables null",
  {
    #### Get estimates ----
    p <- get_estimates(anthro.02, muac, oedema = NULL)

    #### Observed estimates ----
    gam_n <- 106
    gam_p <- 4.9
    sam_n <- 16
    sam_p <- 0.7
    mam_n <- 90
    mam_p <- 4.1

    #### Tests ----
    testthat::expect_s3_class(p, "tbl_df")
    testthat::expect_equal(ncol(p), 7)
    testthat::expect_equal(nrow(p), 1)
    testthat::expect_true(
      all(c("gam_n", "gam_p", "sam_n", "sam_p", "mam_n", "mam_p", "N") %in% names(p))
    )
    testthat::expect_equal(p[[1]][1], gam_n)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), gam_p)
    testthat::expect_equal(p[[3]][1], sam_n)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), sam_p)
    testthat::expect_equal(p[[5]][1], mam_n)
    testthat::expect_equal(round(p[[6]][1] * 100, 1), mam_p)
  }
)

### When grouping variables are supplied ----
testthat::test_that(
  "get_estimates() works OK when grouping variables are supplied",
  {
    #### Get estimates ----
    p <- get_estimates(anthro.02, muac, oedema, raw_muac = FALSE, province)

    #### Observed estimates ----
    gam_n <- 61
    gam_p <- 5.9
    sam_n <- 19
    sam_p <- 1.8
    mam_n <- 42
    mam_p <- 4.1

    #### Tests ----
    testthat::expect_s3_class(p, "tbl_df")
    testthat::expect_equal(ncol(p), 8)
    testthat::expect_equal(nrow(p), 2)
    testthat::expect_true(
      all(c("province", "gam_n", "gam_p", "sam_n", "sam_p", "mam_n", "mam_p", "N")
      %in% names(p))
    )
    testthat::expect_equal(p[[2]][1], gam_n)
    testthat::expect_equal(round(p[[3]][1] * 100, 1), gam_p)
    testthat::expect_equal(p[[4]][1], sam_n)
    testthat::expect_equal(round(p[[5]][1] * 100, 1), sam_p)
    testthat::expect_equal(p[[6]][1], mam_n)
    testthat::expect_equal(round(p[[7]][1] * 100, 1), mam_p)
  }
)

### When `raw_muac` is either `TRUE` or `FALSE` ----
testthat::test_that(
  "When get_estimates() is set to `raw_muac = TRUE`, it filters outliers
  based on `flag_muac`",
  {
    #### Observed results ----
    r <- anthro.01 |>
      mw_wrangle_age(age = age) |>
      mw_wrangle_muac(sex = sex, .recode_sex = TRUE, muac = muac) |>
      get_estimates(muac = muac, raw_muac = TRUE)

    #### Tests ----
    testthat::expect_s3_class(object = r, class = "tbl_df")
    testthat::expect_no_error(object = r)
  }
)


### When `raw_muac` is either `TRUE` or `FALSE` ----
testthat::test_that(
  "When get_estimates() is set to `raw_muac = FALSE`, it filters outliers
  based on `flag_mfaz`",
  {
    #### Observed results ----
    r <- anthro.01 |>
      mw_wrangle_age(age = age) |>
      mw_wrangle_muac(
        sex = sex,
        .recode_sex = TRUE,
        age = age,
        muac = muac,
        .recode_muac = TRUE,
        .to = "cm"
      ) |>
      mutate(muac = recode_muac(muac, .to = "mm")) |>
      get_estimates(muac = muac, raw_muac = FALSE)

    ### Tests ----
    testthat::expect_s3_class(object = r, class = "tbl_df")
    testthat::expect_no_error(object = r)
  }
)


## ---- mw_estimate_prevalence_screening() -------------------------------------


### When grouping variables are not supplied
testthat::test_that(
  "mw_estimate_prevalence_screening() works OK when grouping variables are not supplied",
  {
    #### Get estimates ----
    p <- mw_estimate_prevalence_screening(anthro.02, muac, age, oedema)

    #### Observed estimates ----
    gam_n <- 118
    gam_p <- 5.4
    sam_n <- 29
    sam_p <- 1.3
    mam_n <- 89
    mam_p <- 4.1


    #### Tests ----
    testthat::expect_s3_class(p, "tbl_df")
    testthat::expect_equal(ncol(p), 7)
    testthat::expect_equal(nrow(p), 1)
    testthat::expect_true(
      all(c("gam_n", "gam_p", "sam_n", "sam_p", "mam_n", "mam_p", "N") %in% names(p))
    )
    testthat::expect_equal(p[[1]][1], gam_n)
    testthat::expect_equal(round(p[[2]][1] * 100, 1), gam_p)
    testthat::expect_equal(p[[3]][1], sam_n)
    testthat::expect_equal(round(p[[4]][1] * 100, 1), sam_p)
    testthat::expect_equal(p[[5]][1], mam_n)
    testthat::expect_equal(round(p[[6]][1] * 100, 1), mam_p)
  }
)


### When used on a multiple-area dataset ----
testthat::test_that(
  "mw_estimate_prevalence_screening() works well on a multiple-area dataset with
    different categories of analysis_approach",
  {
    #### Get the prevalence estimates ----
    p <- anthro.04 |>
      mw_wrangle_age(age = age) |> 
      mw_wrangle_muac(sex, muac, age, FALSE, TRUE, "cm") |> 
      mutate(muac = recode_muac(muac, "mm")) |> 
      mw_estimate_prevalence_screening(muac, age, oedema, analysis_unit)

    columns_to_check <- c("gam_n", "gam_p", "sam_n", "sam_p", "mam_n", "mam_p", "N")

    #### test ----
    testthat::expect_vector(select(p, !analysis_unit), size = 3, ncol(8))
    testthat::expect_s3_class(p, "tbl")
    testthat::expect_false(all(sapply(p[2, ][columns_to_check], \(.) all(is.na(.)))))

    #### Unit B: age-weighted prevalence ----
    testthat::expect_true(is.na(p[2, 2][[1]]))
    testthat::expect_equal(round(p[2, 3][[1]] * 100, 1), 12.1)
    testthat::expect_true(is.na(p[2, 4][[1]]))
    testthat::expect_equal(round(p[2, 5][[1]] * 100, 1), 2.9)
    testthat::expect_true(is.na(p[2, 6][[1]]))
    testthat::expect_equal(round(p[2, 7][[1]] * 100, 1), 9.2)
    testthat::expect_equal(p[2, 8][[1]], 1354)

    #### Unit C: Age ratio is problematic but prop >= 0.66 (non-age-weighted p) ----
    testthat::expect_equal(round(p[3, 3][[1]] * 100, 1), 9.1)
    testthat::expect_equal(round(p[3, 5][[1]] * 100, 1), 2.4)
    testthat::expect_equal(round(p[3, 7][[1]] * 100, 1), 6.7)
    testthat::expect_equal(p[3, 8][[1]], 209)
  }
)


## ---- mw_estimate_prevalence_screening2() ------------------------------------


### When grouping variables are given ----
testthat::test_that(
  "mw_estimate_prevalence_screening2() works as expected when grouping vars are specified",
  {
    #### Observed results ----
    p <- anthro.04 |>
      mutate(age_cat = ifelse(age < 24, "6-23", "24-59")) |>
      mw_wrangle_muac(sex = sex, .recode_sex = TRUE, muac = muac) |>
      mw_estimate_prevalence_screening2(
        age_cat = age_cat,
        muac = muac, 
        oedema = oedema, 
        analysis_unit
      )

    #### Tests ----
    testthat::expect_s3_class(p, "tbl_df")

    #### Unit B: age-weighted prevalence ----
    testthat::expect_true(is.na(p[2, 2][[1]]))
    testthat::expect_equal(round(p[2, 3][[1]] * 100, 1), 12.6)
    testthat::expect_true(is.na(p[2, 4][[1]]))
    testthat::expect_equal(round(p[2, 5][[1]] * 100, 1), 3.4)
    testthat::expect_true(is.na(p[2, 6][[1]]))
    testthat::expect_equal(round(p[2, 7][[1]] * 100, 1), 9.1)
    testthat::expect_equal(p[2, 8][[1]], 1365)

    #### Unit C: Age ratio is problematic but prop >= 0.66 (non-age-weighted p) ----
    testthat::expect_equal(round(p[3, 3][[1]] * 100, 1), 9.5)
    testthat::expect_equal(round(p[3, 5][[1]] * 100, 1), 2.9)
    testthat::expect_equal(round(p[3, 7][[1]] * 100, 1), 6.7)
    testthat::expect_equal(p[3, 8][[1]], 210)
  }
)


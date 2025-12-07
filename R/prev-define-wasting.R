#'
#'
#' @keywords internal
#'
#'
define_wasting_muac <- function(muac,
                                oedema = NULL,
                                .cases = c("gam", "sam", "mam")) {
  ## Enforce options in `.cases` ----
  .cases <- match.arg(.cases)

  if (!is.null(oedema)) {
    switch(
      ### Wasting by MUAC including MUAC ----
      .cases,
      "gam" = {
        gam <- ifelse(muac < 125 | oedema == "y", 1, 0)
      },
      "sam" = {
        sam <- ifelse(muac < 115 | oedema == "y", 1, 0)
      },
      "mam" = {
        mam <- ifelse((muac >= 115 & muac < 125 & oedema == "n"), 1, 0)
      }
    )
  } else {
    switch(
      ### Wasting by MUAC without oedema ----
      .cases,
      "gam" = {
        gam <- ifelse(muac < 125, 1, 0)
      },
      "sam" = {
        sam <- ifelse(muac < 115, 1, 0)
      },
      "mam" = {
        mam <- ifelse((muac >= 115 & muac < 125), 1, 0)
      }
    )
  }
}

#'
#'
#' @keywords internal
#'
#'
define_wasting_zscores <- function(zscores,
                                   oedema = NULL,
                                   .cases = c("gam", "sam", "mam")) {
  ## Enforce options in `.cases` ----
  .cases <- match.arg(.cases)

  if (!is.null(oedema)) {
    switch(
      ### Wasting by WFHZ including oedema ----
      .cases,
      "gam" = {
        gam <- ifelse(zscores < -2 | oedema == "y", 1, 0)
      },
      "sam" = {
        sam <- ifelse(zscores < -3 | oedema == "y", 1, 0)
      },
      "mam" = {
        mam <- ifelse((zscores >= -3 & zscores < -2 & oedema == "n"), 1, 0)
      }
    )
  } else {
    switch(
      ### Wasting by MFHZ sem oedema ----
      .cases,
      "gam" = {
        gam <- ifelse(zscores < -2, 1, 0)
      },
      "sam" = {
        sam <- ifelse(zscores < -3, 1, 0)
      },
      "mam" = {
        mam <- ifelse(zscores >= -3 & zscores < -2, 1, 0)
      }
    )
  }
}

#'
#'
#' @keywords internal
#'
#'
define_wasting_combined <- function(zscores,
                                    muac,
                                    oedema = NULL,
                                    .cases = c("cgam", "csam", "cmam")) {
  ## Enforce options in `.cases` ----
  .cases <- match.arg(.cases)

  if (!is.null(oedema)) {
    switch(
      ### Combined wasting including oedema ----
      .cases,
      "cgam" = {
        cgam <- ifelse(zscores < -2 | muac < 125 | oedema == "y", 1, 0)
      },
      "csam" = {
        csam <- ifelse(zscores < -3 | muac < 115 | oedema == "y", 1, 0)
      },
      "cmam" = {
        cmam <- ifelse(
          (zscores >= -3 & zscores < -2) | 
            (muac >= 115 & muac < 125) & 
            oedema == "n", 1, 0
        )
      }
    )
  } else {
    switch(
      ### Combined wasting without oedema ----
      .cases,
      "cgam" = {
        cgam <- ifelse(zscores < -2 | muac < 125, 1, 0)
      },
      "csam" = {
        csam <- ifelse(zscores < -3 | muac < 115, 1, 0)
      },
      "cmam" = {
        cmam <- ifelse(
          (zscores >= -3 & zscores < -2) | 
            (muac >= 115 & muac < 125), 1, 0
        )
      }
    )
  }
}


#'
#' Define wasting
#'
#' @description
#' Determine if a given observation in the data set is wasted or not, and its
#' respective form of wasting (global, severe or moderate) on the basis of
#' z-scores of weight-for-height (WFHZ), muac-for-age (MFAZ), raw MUAC 
#' values and combined case-definition.
#'
#' @param df A `tibble` object. It must have been wrangled using this package's 
#' wrangling functions for WFHZ or MUAC, or both (for combined) as appropriate.
#'
#' @param zscores A vector of class `double` of WFHZ or MFAZ values.
#'
#' @param muac An `integer` or `character` vector of raw MUAC values in
#' millimeters.
#'
#' @param oedema A `character` vector indicating oedema status. Default is NULL.
#' Code values should be "y" for presence and "n" for absence of nutritional 
#' oedema.
#'
#' @param .by A choice of the criterion by which a case is to be defined. Choose 
#' "zscores" for WFHZ or MFAZ, "muac" for raw MUAC and "combined" for combined.
#' Default value is "zscores".
#'
#' @returns The `tibble` object `df` with additional columns named named `gam`, 
#' `sam` and `mam`, each of class `numeric` containing coded values of either 
#' 1 (case) and 0 (not a case). If `.by = "combined"`, additional columns are
#' named `cgam`, `csam` and `cmam`.
#'
#' @examples
#' ## Case-definition by z-scores ----
#' z <- anthro.02 |>
#'   define_wasting(
#'     zscores = wfhz,
#'     muac = NULL,
#'     oedema = oedema,
#'     .by = "zscores"
#'   )
#' head(z)
#'
#' ## Case-definition by MUAC ----
#' m <- anthro.02 |>
#'   define_wasting(
#'     zscores = NULL,
#'     muac = muac,
#'     oedema = oedema,
#'     .by = "muac"
#'   )
#' head(m)
#'
#' ## Case-definition by combined ----
#' c <- anthro.02 |>
#'   define_wasting(
#'     zscores = wfhz,
#'     muac = muac,
#'     oedema = oedema,
#'     .by = "combined"
#'   )
#' head(c)
#'
#' @export
#'
define_wasting <- function(df,
                           zscores = NULL,
                           muac = NULL,
                           oedema = NULL,
                           .by = c("zscores", "muac", "combined")) {

  ## Difuse and evaluate arguments ----
  zscores <- rlang::eval_tidy(enquo(zscores), df)
  muac <- rlang::eval_tidy(enquo(muac), df)
  oedema <- rlang::eval_tidy(enquo(oedema), df)

  ## Enforce options in `.by` ----
  .by <- match.arg(.by)

  ## Enforce class of `zscores` ----
  if(!is.null(zscores)) {
    if (!is.double(zscores)) {
      stop(
        "`zscores` must be of class double not ", 
        class(zscores), ". Please try again."
      )
    }
  }

  ## Enforce class of `muac` ----
  if(!is.null(muac)) {
    if (!(is.numeric(muac) | is.integer(muac))) {
      stop(
        "`muac` must be of class numeric or integer not ", 
        class(muac), ". Please try again."
      )
    }
  }

  ## Enforce class of `oedema` ----
  if(!is.null(oedema)) {
    if (!is.character(oedema)) {
      stop(
        "`oedema` must be of class character not ", 
        class(oedema), ". Please try again."
      )
    }
    ## Enforce code values in `oedema` ----
    if (!(all(levels(as.factor(as.character(oedema))) %in% c("y", "n")))) {
      stop('Values in `oedema` should either be "y" or "n". Please try again.')
    }
  }

  ## Define cases ----
  switch(
    ### By WFHZ or MFAZ and add to the data frame ----
    .by,
    "zscores" = {
      dplyr::mutate(
        .data = df,
        gam = define_wasting_zscores(
          zscores = {{ zscores }},
          oedema = {{ oedema }},
          .cases = "gam"
        ),
        sam = define_wasting_zscores(
          zscores = {{ zscores }},
          oedema = {{ oedema }},
          .cases = "sam"
        ),
        mam = define_wasting_zscores(
          zscores = {{ zscores }},
          oedema = {{ oedema }},
          .cases = "mam"
        )
      )
    },
    ### By MUAC and add to the data frame ----
    "muac" = {
      dplyr::mutate(
        .data = df,
        gam = define_wasting_muac(
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "gam"
        ),
        sam = define_wasting_muac(
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "sam"
        ),
        mam = define_wasting_muac(
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "mam"
        )
      )
    },
    ### By combined add to the data frame ----
    "combined" = {
      dplyr::mutate(
        .data = df,
        cgam = define_wasting_combined(
          zscores = {{ zscores }},
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "cgam"
        ),
        csam = define_wasting_combined(
          zscores = {{ zscores }},
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "csam"
        ),
        cmam = define_wasting_combined(
          zscores = {{ zscores }},
          muac = {{ muac }},
          oedema = {{ oedema }},
          .cases = "cmam"
        )
      )
    }
  )
}

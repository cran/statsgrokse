context("\ndate tools")


context("check_date_inputs()")
# ----------------------------------------------------------

test_that("check_date_inputs() works as expected", {
  expect_error(
    check_date_inputs()
  )
  expect_error(
    check_date_inputs(1,1)
  )
  expect_error({
    check_date_inputs(from="2011-01-01", to="2010-01-01")
  })

  expect_true({
    check_date_inputs(from="2001-01-01", to="2001-01-02", warn=FALSE); TRUE;
  })
  expect_true({
    check_date_inputs(from="2000-01-01", to="2001-01-01", warn=FALSE); TRUE;
  })
  expect_error({
    check_date_inputs(from="2001-01-01", to="2000-01-01"); TRUE;
  })
  expect_true({
    check_date_inputs(from="2011-01-01", to="2011-01-01"); TRUE;
  })
  expect_true({
    check_date_inputs(from="2010-01-01", to="2011-01-01"); TRUE;
  })

  expect_warning({
    check_date_inputs(from="2001-01-01", to="2001-01-02");
  })
  expect_warning({
    check_date_inputs(from="2000-01-01", to="2001-01-01");
  })
  expect_warning({
    check_date_inputs(from="2017-01-01", to="2017-01-01");
  })

})



context("wp_date()")
# ----------------------------------------------------------

date_na   <- c("", "01-01", "2000-01", "2015-02-29")
date_num  <- -10:10
library(stringr)
date_char <-
  apply(
    expand.grid(
      year   = 2004:2006,
      months = str_pad(1:3, 2, "left", "0"),
      days   = str_pad(1:5, 2, "left", "0")
    ),
    1,
    paste0,
    collapse="-"
  )

dates1 <- paste0("2015-03-", 1:32)
dates2 <- paste0("2015-02-", 1:32)
dates3 <-         apply(expand.grid(year=2004:2006, months=0:14, days=-5:33),1, paste0, collapse="-")
dates4 <- as.Date(apply(expand.grid(year=2006,      months=1:12, days= 1:28),1, paste0, collapse="-"))

date_logical <- c(TRUE, TRUE)
date_logical[date_logical==TRUE] <- NA

date_factor <- factor("2012-01-01")

test_that("wp_date() works as expected", {
  expect_is(
    wp_date("2000-01-01"), "Date"
    )
  expect_is(suppressWarnings(
    wp_date(1:10)), "Date"
    )
  expect_warning(
    wp_date(1:10)
    )
  expect_error(
    wp_date()
    )

  expect_true(
    all(is.na(wp_date(date_na)))
    )
  expect_true(
    all(wp_date(date_num, origin=0)== -10:10)
    )
  expect_is(
    wp_date(date_char, origin=0) , "Date"
    )

  expect_true(
    !is.na(wp_date("2012-02-29"))
    )

  expect_true(
    suppressWarnings(
      wp_date(as.numeric(as.Date("2015-01-01"))) == "2015-01-01"
      )
    )
  expect_true(
    suppressWarnings(
      wp_date(16436) == "2015-01-01"
      )
    )
  expect_true(
   all( wp_date(date_char, format = "%Y-%m-%d") == wp_date(date_char) )
  )

  expect_null(
    wp_date.default(NULL)
  )
  expect_null(
    wp_date(NULL)
  )

  expect_is(
    wp_date(date_logical), "Date"
  )

  expect_error(
    wp_date(TRUE)
  )

  expect_true(
    wp_date(as.Date(0, origin="1970-01-01"))=="1970-01-01"
  )

  expect_is(wp_date(date_factor), "Date")
  expect_true(wp_date(date_factor)=="2012-01-01")

  expect_true( wp_day(as.POSIXlt("2012-02-29")) == 29 )
  expect_null( wp_day(NULL) )

  expect_true(
    wp_date( as.POSIXct("2017-03-19 23:20:00", tz="UTC") ) == "2017-03-19" &
    wp_date( as.POSIXct("2017-03-20 0:20:00", tz="UTC") ) == "2017-03-20"
  )
})



context("wp_day()")
# ----------------------------------------------------------

test_that("wp_day() works as expected.", {
  expect_true(  all(is.na(wp_day(date_na))) )
  expect_true(  suppressWarnings(all(wp_day(date_num)== c(22:31,1:11))) )
  expect_true(  is.numeric(wp_day(date_char)))
})



context("wp_year()")
# ----------------------------------------------------------

test_that("wp_year() works as expected.", {
  expect_true(  all(is.na(wp_year(date_na))) )
  expect_true(  suppressWarnings(all(wp_year(date_num) %in% 1969:1970)) )
  expect_is(  wp_year(date_char) , "numeric")
})



context("wp_month()")
# ----------------------------------------------------------

test_that("wp_month() works as expected.", {
  expect_true(  all(is.na(wp_month(date_na))) )
  expect_true(  suppressWarnings(all(wp_month(date_num) %in% c(12,1))) )
  expect_is(  wp_month(date_char) , "numeric")
})



context("wp_yearmonth()")
# ----------------------------------------------------------

test_that("wp_yearmonth() works as expected.", {
  # expect_true(  all(is.na(wp_yearmonth(date_na))) )
  expect_true(  suppressWarnings(all(wp_yearmonth(date_num) %in% c(196912,197001))) )
  expect_is(  wp_yearmonth(date_char) , "character")
  expect_null( wp_yearmonth(NULL) )
})





















#' Read CSV format files silently
#'
#' This function
#' 1) checks for an existent CSV file and,
#' 2) reads it silently.
#'
#' If the file does not exists throws an error
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @param filename A path to the CSV file (A character string)
#'
#' @return At tibble object (data.frame) of the CSV file data
#'
#' @examples
#' path <- system.file("extdata", "accident_2013.csv.bz2", package = "CourseraFARS")
#'
#' fars_read(path)
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Make filename for FARS files
#'
#' Given a year creates a custom filename for FARS files.
#'
#' @param year Numeric. A number to format the filename
#' @return A string with a custon filename
#' @examples
#' make_filename(2013)
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Batch import of FARS data
#'
#' Iterate over a numeric year vector that reads FARS data for each #' year. If file does not exists, it returns a warning.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom magrittr "%>%"
#'
#' @param years A vector or list of years in numeric or integer format.
#'
#' @return A list of tibbles. Each tibble contains two columns, MONTH and year.　
#' Returns NULL and a warning, if the file does not exist.
#' @examples
#' \dontrun{fars_read_years(2013:2015)}
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Summarize FARS years
#'
#' Count the number of observations by month in the given years
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @param years A vector or list of years (numeric or integer) that will be
#' searched in the data
#'
#' @return Returns a pivot tibble (data frame) with months in rows and selected
#' years in columns containing the number of accidents. Returns a warning for
#' every input year that does not exist in the datasets. Returns an error (no
#' results) if a different than numeric or integer input is presented.
#'
#' @examples
#' \dontrun{fars_summarize_years(2013:2015)}
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Draw a FARS data map for a given year and state
#'
#' Draws a map for a given year and state, one point for observation. It will
#' throw an error if state.num is not in the dataset. If no observations are found,
#' it will throw a message.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @param state.num The number of a state in the US as used in the FARS data
#' sets. It should be numeric or integer.
#' @param year The year of analysis (numeric or integer)
#'
#' @return Returns a plot of the accidents based on the \code{state.num} and
#' \code{year} inputs. Returns an error if the state or year do not exist in the
#' data set.
#'
#' @examples
#' \dontrun{fars_map_state(45, 2015)}
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}

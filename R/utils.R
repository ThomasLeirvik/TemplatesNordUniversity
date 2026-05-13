## Internal helpers shared by all output formats. ---------------------------

#' Locate a file shipped with the installed package.
#' @noRd
pkg_template <- function(name) {
  system.file("rmarkdown", "resources", name, package = "NordUniversityTemplates",
              mustWork = TRUE)
}

#' Locate the lua filter shipped with the package.
#' @noRd
pkg_lua <- function(name) {
  system.file("rmarkdown", "lua", name, package = "NordUniversityTemplates",
              mustWork = TRUE)
}

#' Build the pandoc citation_package argument.
#' @noRd
citation_package_arg <- function(value) {
  value <- value[1]
  if (value == "none") {
    warning("citation_package = 'none' is deprecated; use 'default' instead.")
    value <- "default"
  }
  value <- match.arg(value, c("default", "natbib", "biblatex"))
  if (value != "default") paste0("--", value) else character()
}

#' Construct pandoc --latex-engine flag.
#' @noRd
latex_engine_arg <- function(engine) {
  c("--pdf-engine", engine)
}

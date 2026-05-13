#' Article-based Master Thesis (Nord University Business School)
#'
#' R Markdown output format for an article-based ("kappa + artikkel") master
#' thesis at Nord University Business School. The format supports two
#' bibliographies: one for the kappa/introduction (`bibliography_chapter1`)
#' and one for the scientific article (`bibliography_chapter2`), implemented
#' via the bundled `multiple-bibliographies.lua` pandoc filter.
#'
#' @inheritParams master_mono
#'
#' @export
master_article <- function(toc = TRUE,
                           toc_depth = 4,
                           number_sections = TRUE,
                           fig_width = 6.5,
                           fig_height = 4.5,
                           fig_crop = "auto",
                           fig_caption = TRUE,
                           dev = "pdf",
                           df_print = "default",
                           keep_tex = FALSE,
                           keep_md = FALSE,
                           latex_engine = "xelatex",
                           citation_package = c("default", "natbib", "biblatex"),
                           includes = NULL,
                           md_extensions = NULL,
                           pandoc_args = NULL,
                           template = pkg_template("article.tex")) {

  args <- character()
  if (isTRUE(toc)) args <- c(args, "--toc", "--toc-depth", as.character(toc_depth))
  if (isTRUE(number_sections)) args <- c(args, "--number-sections")
  if (!is.null(template) && !identical(template, "default"))
    args <- c(args, "--template", rmarkdown::pandoc_path_arg(template))
  args <- c(args, latex_engine_arg(latex_engine))
  args <- c(args, citation_package_arg(citation_package))
  args <- c(args, rmarkdown::includes_to_pandoc_args(includes))
  args <- c(args, pandoc_args)

  rmarkdown::output_format(
    knitr = rmarkdown::knitr_options_pdf(fig_width, fig_height, fig_crop, dev),
    pandoc = rmarkdown::pandoc_options(
      to = "latex",
      from = rmarkdown::from_rmarkdown(fig_caption, md_extensions),
      args = args,
      latex_engine = latex_engine,
      keep_tex = keep_tex,
      lua_filters = pkg_lua("multiple-bibliographies.lua")
    ),
    clean_supporting = !keep_tex,
    keep_md = keep_md,
    df_print = df_print
  )
}

#' Monography Master Thesis (Nord University Business School)
#'
#' R Markdown output format for a monography-based master thesis at Nord
#' University Business School. Produces a PDF using xelatex with Times New
#' Roman (or the `newtxtext`/`newtxmath` Times-clone fallback when the system
#' font is unavailable), a Nord-branded title page, table of contents, and
#' optional list of figures / list of tables.
#'
#' @param toc Logical. Include a table of contents (default `TRUE`).
#' @param toc_depth Integer. Depth of the table of contents.
#' @param number_sections Logical. Number sections (default `TRUE`).
#' @param fig_width,fig_height Default figure dimensions in inches.
#' @param fig_crop Auto-crop figures with `pdfcrop` if available.
#' @param fig_caption Logical. Render figure captions.
#' @param dev Graphics device used by knitr (default `"pdf"`).
#' @param df_print Data-frame print method passed to rmarkdown.
#' @param keep_tex Logical. Keep the intermediate `.tex` file.
#' @param keep_md Logical. Keep the intermediate `.md` file.
#' @param latex_engine LaTeX engine; defaults to `"xelatex"` (required for
#'   Times New Roman via `fontspec`).
#' @param citation_package One of `"default"`, `"natbib"`, `"biblatex"`.
#' @param includes Named list passed to [rmarkdown::includes()].
#' @param md_extensions Markdown extensions for pandoc.
#' @param pandoc_args Extra pandoc command-line arguments.
#' @param template Path to the LaTeX template (advanced).
#'
#' @export
master_mono <- function(toc = TRUE,
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
                        template = pkg_template("monography.tex")) {

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
      keep_tex = keep_tex
    ),
    clean_supporting = !keep_tex,
    keep_md = keep_md,
    df_print = df_print
  )
}

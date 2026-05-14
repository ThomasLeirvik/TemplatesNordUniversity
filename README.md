# NordUniversityTemplates

R Markdown / `bookdown` templates for writing **assignments**, **bachelor theses**, **monography master theses**, and **article-based master theses** at **Nord University Business School**, with a Nord-branded title page and a layout that follows the official requirements.

This package is the modern successor to the older `moppNord` package. It fixes the two long-standing issues that have caused trouble for students:

- **Font** — the body font is **Times New Roman** (an approved font for the master thesis). The old template used Calibri, which is not bundled with macOS and so Mac users routinely hit a missing-font error when knitting. Times New Roman ships with both Windows and macOS out of the box; on systems without it (e.g. clean Linux/Docker), the template falls back automatically to the free **TeX Gyre Termes** (a Times-compatible font that comes with every TeX Live / TinyTeX installation), so the document still compiles.
- **LaTeX preamble** — modernised to compile cleanly with current LaTeX/Pandoc. Deprecated packages (`fixltx2e`, `ifxetex` + `ifluatex`, `xltxtra`, `xunicode`) have been replaced with the modern `iftex` + `fontspec` combination, which is the supported way to detect the engine and load fonts in 2024+ LaTeX.

The templates produce PDF via **xelatex** and include:

- Nord-branded title page (TikZ, English or Norwegian)
- Table of contents (`toc`), optional list of figures and list of tables (`lists: true`)
- Optional appendix (`appendices: true`)
- Single bibliography (monography / assignment) or two separate bibliographies (article-based: one for the *kappa*, one for the article) via the bundled `multiple-bibliographies` pandoc filter

## Installation

You need:

- **R** ≥ 4.0 and **RStudio**
- A working **LaTeX** distribution — the easiest way is `tinytex`:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

- `devtools` (only for installation from GitHub):

```r
install.packages("devtools")
```

Then install the package from GitHub:

```r
devtools::install_github("ThomasLeirvik/TemplatesNordUniversity")
```

**Restart R** after installation so that the new templates appear in RStudio's *File → New File → R Markdown… → From Template* dialog.

### macOS users — no extra steps required

Unlike the old template, **you do not need to install Calibri**. Times New Roman is already installed on every macOS system and is used directly.

### Linux / Docker users

If you are on a system without Times New Roman installed (most clean Linux containers), the template will silently fall back to **TeX Gyre Termes**, a freely licensed Times-compatible font that comes with every TeX Live / TinyTeX installation. The visual result is essentially identical and is still considered an acceptable rendering of "Times" for the thesis.

## Using a template in RStudio

1. *File → New File → R Markdown… → From Template*
2. Choose one of:
   - **Nord — Bachelor Thesis**
   - **Nord — Monography Master Thesis**
   - **Nord — Article-based Master Thesis**
   - **Nord — Assignment / Arbeidskrav**
3. Give the new project folder a name and click *OK*. RStudio creates a folder containing:
   - `skeleton.Rmd` — write your work here (rename it if you like)
   - One or two `.bib` files — put your BibTeX references here
   - `nordlogoen.jpg` / `nordlogono.jpg` — Nord logos (English / Norwegian)
4. Edit the YAML header at the top of the `.Rmd` (title, candidate number, course code).
5. Press **Knit** to produce the PDF.

### Switching to Norwegian

Add this line to the YAML header:

```yaml
lang: nb
```

The template will automatically switch all built-in labels (Innholdsfortegnelse, Litteraturliste, Figur, Tabell, Ligning, Appendiks…) to Norwegian and use the Norwegian Nord logo.

## Citation syntax

Citations follow the standard pandoc/R Markdown convention — write them inline in the `.Rmd`:

| You write              | You get                              |
| ---------------------- | ------------------------------------ |
| `@key`                 | *Author (year)*                      |
| `[@key]`               | *(Author, year)*                     |
| `-@key`                | *(year)*                             |
| `[@key1; @key2]`       | *(Author1, year; Author2, year)*     |

Your `.bib` file can be exported directly from **Zotero**, **Mendeley** or **EndNote**.

## Article-based thesis — two bibliographies

The article-based template defines two BibTeX files:

- `chapter1.bib` — used in the kappa (introduction)
- `chapter2.bib` — used in the scientific article

The bundled `multiple-bibliographies.lua` pandoc filter takes care of splitting the references list into two parts. Cite normally with `@key` / `[@key]`; the filter routes each entry to the correct list based on where it is cited.

## Repository layout

```
NordUniversityTemplates/
├── DESCRIPTION                  # R package metadata
├── NAMESPACE                    # exported functions
├── LICENSE                      # GPL-3
├── README.md                    # this file
├── R/
│   ├── master_mono.R            # monography output format
│   ├── master_article.R         # article-based output format
│   ├── bachelor_thesis.R        # bachelor thesis output format
│   ├── assignment.R             # assignment / arbeidskrav format
│   └── utils.R                  # shared internal helpers
└── inst/
    └── rmarkdown/
        ├── lua/
        │   └── multiple-bibliographies.lua
        ├── resources/
        │   ├── monography.tex   # LaTeX template (book class, Nord teal)
        │   ├── article.tex      # LaTeX template (book class, dual bib, Nord teal)
        │   ├── bachelor.tex     # LaTeX template (book class, Nord green)
        │   └── assignment.tex   # LaTeX template (article class)
        └── templates/
            ├── monography/{template.yaml, skeleton/...}
            ├── article/   {template.yaml, skeleton/...}
            ├── bachelor/  {template.yaml, skeleton/...}
            └── assignment/{template.yaml, skeleton/...}
```

## License

GPL-3. See [LICENSE](LICENSE).

## Feedback

Please open an issue on GitHub for bug reports or suggestions.

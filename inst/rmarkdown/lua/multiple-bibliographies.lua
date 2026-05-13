--[[
multiple-bibliographies – create multiple bibliographies inside one document.

Originally written by Albert Krewinkel (2018-2021); included here under the
permissive licence stated below.  Lightly cleaned up for Pandoc >= 2.11
(no more pandoc-citeproc compatibility branch needed for current users; the
old branch is kept so the filter still works if anyone is stuck on an older
Pandoc).

Copyright © 2018-2021 Albert Krewinkel
Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]
local utils            = require 'pandoc.utils'
local stringify        = utils.stringify
local run_json_filter  = utils.run_json_filter

local all_cites = {}
local doc_meta  = pandoc.Meta{}

local refs_div = pandoc.Div({}, pandoc.Attr('refs'))
local refs_div_with_properties

local function run_citeproc(doc, quiet)
  if PANDOC_VERSION >= '2.11' then
    return run_json_filter(
      doc,
      'pandoc',
      {'--from=json', '--to=json', '--citeproc', quiet and '--quiet' or nil}
    )
  else
    return run_json_filter(
      doc,
      'pandoc-citeproc',
      {FORMAT, quiet and '-q' or nil}
    )
  end
end

local function resolve_doc_citations(doc)
  local meta = doc.meta
  local orig_bib = meta.bibliography
  meta.bibliography = pandoc.MetaList{orig_bib}
  for name, value in pairs(meta) do
    if name:match('^bibliography_') then
      table.insert(meta.bibliography, value)
    end
  end
  table.insert(doc.blocks, refs_div)
  doc = run_citeproc(doc)
  refs_div_with_properties = table.remove(doc.blocks)
  doc.meta.bibliography = orig_bib
  return doc
end

local function meta_for_pandoc_citeproc(bibliography)
  local fields = {
    'bibliography', 'references', 'csl', 'citation-style',
    'link-citations', 'citation-abbreviations', 'lang',
    'suppress-bibliography', 'reference-section-title',
    'notes-after-punctuation', 'nocite'
  }
  local new_meta = pandoc.Meta{}
  for _, field in ipairs(fields) do
    new_meta[field] = doc_meta[field]
  end
  new_meta.bibliography = bibliography
  return new_meta
end

local function create_topic_bibliography(div)
  local name = div.identifier:match('^refs([_%w]*)$')
  local bibfile = name and doc_meta['bibliography' .. name]
  if not bibfile then return nil end
  local tmp_blocks = {pandoc.Para(all_cites), refs_div}
  local tmp_meta   = meta_for_pandoc_citeproc(bibfile)
  local tmp_doc    = pandoc.Pandoc(tmp_blocks, tmp_meta)
  local res        = run_citeproc(tmp_doc, true)
  div.content      = res.blocks[2].content
  div.classes      = refs_div_with_properties.classes
  div.attributes   = refs_div_with_properties.attributes
  return div
end

return {
  {
    Cite = function (c) all_cites[#all_cites + 1] = c end,
    Meta = function (m) doc_meta = m end,
  },
  { Pandoc = resolve_doc_citations },
  { Div    = create_topic_bibliography },
}

-- Presentation-only transformations for the integrated report.
-- Supports the Pandoc bundled with RStudio, including Pandoc 3.1.3.
-- No analytical text, code, table cells or data values are changed.

local table_number = 0
local figure_number = 0
local is_word = FORMAT == 'docx'
local is_latex = FORMAT:match('latex') ~= nil

-- Widths measured from the supplied manual Word reference.
-- The expected-count and by-thread layouts are the documented new schemas.
local table_layouts = {
  {key="research_questions", headers="Question|Analytical contribution", caption="Connected research questions and analytical contributions", inches=6.1, ratios={0.5,0.5}},
  {key="data_audit", headers="metric|value", caption="Data and reply-definition audit", inches=4.663889, ratios={0.882370459,0.117629541}},
  {key="thread_composition", headers="Thread ID|Thread title|Raw|Clean|Authors", caption="Selected discussions; author counts are not additive across threads", inches=6.1, ratios={0.16,0.46,0.10,0.12,0.16}},
  {key="variable_definitions", headers="Variable or object|Definition and unit", caption="Analytical variables and units", inches=6.1, ratios={0.5,0.5}},
  {key="rq1_indicators", headers="Candidate indicator|Comments|Percent of corpus", caption="Non-exclusive lexical indicators", inches=6.1, ratios={0.523080387,0.240824139,0.236095474}},
  {key="rq1_contextual_examples", headers="Comment ID|Contextual interpretation", caption="Contextual examples of responsibility and verification", inches=6.1, ratios={0.5,0.5}},
  {key="rq2_observed", headers="Specific practice|No reply|Reply|Total|Reply percent", caption="Specific verification mention and retained direct reply", inches=4.410417, ratios={0.309242639,0.174775626,0.130688081,0.118091639,0.267202015}},
  {key="rq2_expected", headers="Specific practice|No reply|Reply", caption="Expected cell counts under independence", inches=3.3, ratios={0.4,0.3,0.3}},
  {key="rq3_candidate_partitions", headers="k|mean_silhouette|minimum_size|maximum_size|admissible|selected", caption="Candidate partitions; selected marks the declared rule", inches=5.802083, ratios={0.041891083,0.236744464,0.209455416,0.217474566,0.161579892,0.132854578}},
  {key="rq3_cluster_profiles", headers="cluster|n_comments|mean_silhouette|median_retained_tokens|top_terms", caption="Exploratory profiles; top terms are descriptors, not validated theme names", inches=6.1, ratios={0.100427807,0.177754011,0.207165775,0.222032086,0.292620321}},
  {key="rq3_comment_examples", headers="cluster|role|comment_id|text", caption="Medoid and lowest-silhouette examples for contextual inspection", inches=6.1, ratios={0.101369568,0.242424242,0.180524102,0.475682088}},
  {key="rq3_sensitivity", headers="Method|k|mean_silhouette|sizes|admissible", caption="Selected diagnostic partition within each linkage/distance specification", inches=4.615972, ratios={0.303595607,0.052655333,0.297577855,0.143072063,0.203099142}},
  {key="rq4_network_metrics", headers="Metric|Value", caption="Directed author network properties", inches=3.321528, ratios={0.745348108,0.254651892}},
  {key="rq4_centrality", headers="Author|In-degree|Reply events received|Normalised betweenness", caption="Participants ranked by in-degree, then betweenness", inches=6.1, ratios={0.225454545,0.141069519,0.30973262,0.323743316}},
  {key="rq4_receiver_clusters", headers="Receiver cluster|Comments|Comments with reply|Reply percent|Incoming reply events", caption="Descriptive reply outcomes by receiving-comment cluster", inches=6.1, ratios={0.144812834,0.172620321,0.243743316,0.170802139,0.26802139}},
  {key="session_info", headers="Package|Version", caption="R version 4.5.3 - full session information is exported", inches=1.689583, ratios={0.576654336,0.423345664}},
  {key="rq2_by_thread", headers="Thread|FALSE n|FALSE reply %|TRUE n|TRUE reply %", caption="Reply proportions within each thread and supplied label; n/a means no comments in that category", inches=6.1, ratios={0.2,0.2,0.2,0.2,0.2}},
}

local function page_break()
  if is_latex then
    return pandoc.RawBlock('latex', '\\clearpage')
  elseif is_word then
    return pandoc.RawBlock('openxml',
      '<w:p><w:pPr><w:spacing w:before="0" w:after="0" w:line="1" w:lineRule="exact"/></w:pPr><w:r><w:br w:type="page"/></w:r></w:p>')
  end
end

function Meta(meta)
  -- Put the shared, confirmed roster and contribution shares on the cover,
  -- before the native TOC. Unknown details remain explicitly marked.
  local members = meta['group-members'] and pandoc.utils.stringify(meta['group-members']) or ''
  if members ~= '' then
    local authors = pandoc.Inlines({pandoc.Str('Group 36')})
    for member in (members .. '|||'):gmatch('(.-)|||') do
      member = member:gsub('^%s+', ''):gsub('%s+$', '')
      authors:insert(pandoc.LineBreak())
      authors:insert(pandoc.Str(member))
    end
    meta.author = pandoc.MetaInlines(authors)
  end
  -- Native title/date metadata is rendered before the native table of
  -- contents in both PDF and Word. Keep the supplied title-page ordering.
  local repository = meta['repository-url'] and pandoc.utils.stringify(meta['repository-url']) or ''
  if repository ~= '' then
    local date = meta.date and pandoc.utils.stringify(meta.date) or ''
    local inlines = pandoc.Inlines({})
    if date ~= '' then
      inlines:insert(pandoc.Str(date))
      inlines:insert(pandoc.LineBreak())
    end
    inlines:insert(pandoc.Strong({pandoc.Str('Code and data repository:')}))
    inlines:insert(pandoc.LineBreak())
    inlines:insert(pandoc.Link({pandoc.Str(repository)}, repository))
    meta.date = pandoc.MetaInlines(inlines)
  end
  return meta
end

local function has_number(blocks, kind)
  return pandoc.utils.stringify(blocks):match('^' .. kind .. '%s+%d+%s*[:%.]') ~= nil
end

local function numbered_caption(blocks, kind, number)
  local out = pandoc.List(blocks)
  if not has_number(blocks, kind) then
    local prefix = {pandoc.Strong({pandoc.Str(kind .. ' ' .. number .. ':')}), pandoc.Space()}
    if #out > 0 and (out[1].t == 'Para' or out[1].t == 'Plain') then
      for i = #prefix, 1, -1 do out[1].content:insert(1, prefix[i]) end
    else
      out:insert(1, pandoc.Para(prefix))
    end
  end
  return out
end

function Header(header)
  if header.level == 1 then
    -- The reference uses a fresh page for every major section. Word's
    -- Heading 1 style handles this without a redundant page-break paragraph.
    if is_latex then return {page_break(), header} end
    return header
  elseif header.classes:includes('page-break') then
    -- Only explicitly marked subsections get manual breaks. The reference
    -- does not start every Heading 2 or Heading 3 on a fresh page.
    local br = page_break()
    if br then return {br, header} end
  end
end

function Div(div)
  -- A marked block can start a table on a fresh page without altering it.
  if div.classes:includes('page-break') then
    local br = page_break()
    if br then
      local blocks = pandoc.List({br})
      blocks:extend(div.content)
      return blocks
    end
  end
end

local function table_layout(tbl)
  local caption = pandoc.utils.stringify(tbl.caption.long or {})
    :gsub('^Table%s+%d+[:%.]%s*', '')
  for _, layout in ipairs(table_layouts) do
    if caption == layout.caption and #layout.ratios == #tbl.colspecs then return layout end
  end
  local headers = {}
  if tbl.head and #tbl.head.rows > 0 then
    for _, cell in ipairs(tbl.head.rows[1].cells) do
      headers[#headers + 1] = pandoc.utils.stringify(cell.contents)
    end
  end
  local signature = table.concat(headers, '|')
  for _, layout in ipairs(table_layouts) do
    if signature == layout.headers and #layout.ratios == #tbl.colspecs then return layout end
  end
  return nil
end

local function normalise_columns(tbl, layout)
  local widths, sum, positive = {}, 0, 0
  for i, spec in ipairs(tbl.colspecs) do
    widths[i] = layout and layout.ratios[i] or (tonumber(spec[2]) or 0)
    if widths[i] > 0 then sum = sum + widths[i]; positive = positive + 1 end
  end
  local default_width = positive > 0 and sum / positive or 1
  sum = 0
  for i, width in ipairs(widths) do
    if width <= 0 then widths[i] = default_width end
    sum = sum + widths[i]
  end
  local specs = tbl.colspecs
  for i, spec in ipairs(specs) do spec[2] = widths[i] / sum end
  tbl.colspecs = specs
end

local function word_table_xml(tbl, layout)
  -- Render just this table with Pandoc, then adjust its geometry in memory.
  -- Pandoc's native DOCX writer otherwise forces left alignment, overriding
  -- reference-table styles. No Python, R postprocessor or external program
  -- is needed; pandoc.zip is bundled with the supported Pandoc runtime.
  if not pandoc.zip or not pandoc.zip.Archive then
    error('Table formatting requires Pandoc with pandoc.zip support (tested with 3.1.3). Please update RStudio/Pandoc.')
  end
  local archive = pandoc.zip.Archive(pandoc.write(pandoc.Pandoc({tbl}), 'docx'))
  local document
  for _, entry in ipairs(archive.entries) do
    if entry.path == 'word/document.xml' then document = entry:contents(); break end
  end
  local xml = document and document:match('(<w:tbl>.-</w:tbl>)')
  if not xml then error('Could not render a Word table for layout.') end
  if xml:find('r:embed=') or xml:find('r:id=') or xml:find('<w:footnoteReference') then
    error('A table contains linked media/footnotes requiring a separate DOCX relationship. Review its formatting explicitly.')
  end
  local total_width = math.floor(((layout and layout.inches) or 6.1) * 1440 + 0.5)
  xml = xml:gsub('<w:tblPr>(.-)</w:tblPr>', function(properties)
    properties = properties:gsub('<w:tblW[^>]*/>', '')
      :gsub('<w:jc[^>]*/>', ''):gsub('<w:tblInd[^>]*/>', '')
    return '<w:tblPr><w:tblW w:type="dxa" w:w="' .. total_width .. '"/>' ..
      '<w:jc w:val="center"/><w:tblInd w:type="dxa" w:w="0"/>' .. properties .. '</w:tblPr>'
  end, 1)
  local column_widths, remaining = {}, total_width
  for i, spec in ipairs(tbl.colspecs) do
    local width = i == #tbl.colspecs and remaining or math.floor(total_width * spec[2] + 0.5)
    remaining = remaining - width
    column_widths[#column_widths + 1] = '<w:gridCol w:w="' .. width .. '"/>'
  end
  xml = xml:gsub('<w:tblGrid>.-</w:tblGrid>', '<w:tblGrid>' .. table.concat(column_widths) .. '</w:tblGrid>', 1)
  xml = xml:gsub('<w:tr>(.-)</w:tr>', function(row)
    if row:find('<w:trPr>') then
      row = row:gsub('<w:trPr>', '<w:trPr><w:cantSplit/>', 1)
    else
      row = '<w:trPr><w:cantSplit/></w:trPr>' .. row
    end
    return '<w:tr>' .. row .. '</w:tr>'
  end)
  return pandoc.RawBlock('openxml', xml)
end

local function break_identifier(str)
  local text = str.text
  if not ((text:match('^%d+$') and #text >= 7) or
          (text:match('^[%w_]+$') and text:find('_'))) then return nil end
  local out, start, run = pandoc.Inlines({}), 1, 0
  for i = 1, #text do
    run = run + 1
    if i < #text and (text:sub(i, i) == '_' or run >= 4) then
      out:insert(pandoc.Str(text:sub(start, i)))
      out:insert(pandoc.RawInline('latex', '\\allowbreak{}'))
      start, run = i + 1, 0
    end
  end
  out:insert(pandoc.Str(text:sub(start)))
  return out
end

local function break_header_word(str)
  if not str.text:match('^[%w_]+$') or #str.text < 3 then return nil end
  local out = pandoc.Inlines({})
  for i = 1, #str.text do
    out:insert(pandoc.Str(str.text:sub(i, i)))
    if i < #str.text then
      -- Higher penalty than a normal word-space: used only when a narrow
      -- reference column cannot hold the full label at the required 12 pt.
      out:insert(pandoc.RawInline('latex', '\\penalty500\\relax{}'))
    end
  end
  return out
end

local function latex_grid(tbl, latex, layout)
  local width = (layout and layout.inches) or 6.1
  local specs, n = {}, #tbl.colspecs
  for _, spec in ipairs(tbl.colspecs) do
    local align = spec[1] == 'AlignRight' and '\\raggedleft' or
      (spec[1] == 'AlignCenter' and '\\centering' or '\\raggedright')
    specs[#specs + 1] = '>{' .. align .. '\\arraybackslash}p{\\dimexpr ' ..
      string.format('%.7f', width * spec[2]) .. 'in-2\\tabcolsep-' ..
      string.format('%.7f', (n + 1) / n) .. '\\arrayrulewidth\\relax}'
  end
  local preamble = '\\begin{longtable}[c]{|' .. table.concat(specs, '|') .. '|}'
  local changed
  latex, changed = latex:gsub('\\begin{longtable}%b[]%s*%b{}', function() return preamble end, 1)
  if changed ~= 1 then error('Could not apply the PDF table grid safely.') end
  latex = latex:gsub('\\toprule\\noalign{}', '\\hline')
    :gsub('\\midrule\\noalign{}', '\\hline')
    :gsub('\\bottomrule\\noalign{}', '')
    :gsub('\\toprule', '\\hline'):gsub('\\midrule', '\\hline'):gsub('\\bottomrule', '')
    :gsub('\\\\%*%s*\n', '\\\\* \\hline\n')
    :gsub('\\\\%s*\n', '\\\\ \\hline\n')
    :gsub('\\hline%s*\\hline', '\\hline')
  return '\\begingroup\n\\setlength{\\arrayrulewidth}{0.5pt}\n\\setlength{\\tabcolsep}{5pt}\n' .. latex .. '\n\\endgroup'
end

function Table(tbl)
  local layout = table_layout(tbl)
  if is_word or is_latex then normalise_columns(tbl, layout) end
  if is_latex then tbl = tbl:walk({Str = break_identifier}) end
  local bold_headers = layout and (
    layout.key == 'research_questions' or layout.key == 'variable_definitions' or
    layout.key == 'rq4_centrality' or layout.key == 'rq4_receiver_clusters')
  if tbl.head then
    for _, row in ipairs(tbl.head.rows) do
      for _, cell in ipairs(row.cells) do
        for i, block in ipairs(cell.contents) do
          block = block:walk({Strong = function(strong) return strong.content end})
          if is_latex then block = block:walk({Str = break_header_word}) end
          if block.t == 'Plain' or block.t == 'Para' then
            if bold_headers then block.content = {pandoc.Strong(block.content)} end
          end
          cell.contents[i] = block
        end
      end
    end
  end
  local caption = tbl.caption.long
  if not caption or #caption == 0 then
    if is_word then return word_table_xml(tbl, layout) end
    if is_latex then
      return pandoc.RawBlock('latex', latex_grid(tbl, pandoc.write(pandoc.Pandoc({tbl}), 'latex'), layout))
    end
    return nil
  end
  table_number = table_number + 1

  if is_word then
    -- Keep only the final table row with the following caption. The reference
    -- style has keepNext=true and keepLines=false; preceding rows may paginate.
    local last_row
    if tbl.foot and #tbl.foot.rows > 0 then
      last_row = tbl.foot.rows[#tbl.foot.rows]
    else
      for _, body in ipairs(tbl.bodies) do
        if #body.body > 0 then last_row = body.body[#body.body] end
      end
      if not last_row and tbl.head and #tbl.head.rows > 0 then
        last_row = tbl.head.rows[#tbl.head.rows]
      end
    end
    if last_row then
      for _, cell in ipairs(last_row.cells) do
        local blocks = pandoc.List()
        for _, block in ipairs(cell.contents) do
          -- Plain cells use Pandoc's Compact style even inside a custom Div.
          -- An equivalent Para lets the explicit last-row style take effect.
          blocks:insert(block.t == 'Plain' and pandoc.Para(block.content) or block)
        end
        cell.contents = {pandoc.Div(blocks,
          pandoc.Attr('', {}, {['custom-style'] = 'Table Last Row'}))}
      end
    end
    tbl.caption.long = {}
    tbl.caption.short = nil
    local caption_blocks = numbered_caption(caption, 'Table', table_number)
    return {word_table_xml(tbl, layout), pandoc.Div(caption_blocks,
      pandoc.Attr('', {}, {['custom-style'] = 'Table Caption'}))}
  elseif is_latex then
    -- Render the caption inside the longtable so that it remains attached
    -- to the final data row when the table spans more than one page.
    local identifier = tbl.identifier
    tbl.caption.long = {}
    tbl.caption.short = nil
    tbl.identifier = ''
    local latex = pandoc.write(pandoc.Pandoc({tbl}), 'latex')
    local caption_tex = pandoc.write(pandoc.Pandoc(caption), 'latex'):gsub('%s+$', '')
    local label = ''
    if identifier and identifier ~= '' then
      -- Pandoc identifiers are used verbatim by its normal LaTeX writer.
      label = '\\label{' .. identifier .. '}'
    end
    local command
    if has_number(caption, 'Table') then
      command = '\\caption*{' .. caption_tex .. label .. '}\\tabularnewline\n'
    else
      command = '\\caption{' .. caption_tex .. label .. '}\\tabularnewline\n'
    end
    -- The caption is a final body row, not a longtable footer. A footer
    -- can be emitted alone when its measured height differs from the last
    -- table chunk. Keep the final data row and caption in one unbreakable
    -- row transition instead; preceding data rows can still paginate.
    -- Use a plain rule here: longtable hline introduces an internal negative
    -- break penalty, which would defeat the starred row ending.
    latex = latex_grid(tbl, latex, layout)
    local replaced
    latex, replaced = latex:gsub('\\\\%s*\\hline%s*\\end{longtable}', function()
      return '\\\\* \\noalign{\\nobreak\\hrule height\\arrayrulewidth\\nobreak}\n' .. command .. '\\end{longtable}'
    end, 1)
    if replaced ~= 1 then
      error('report-layout.lua: final table row not found; cannot safely keep its caption attached.')
    end
    return pandoc.RawBlock('latex',
      '\\setcounter{table}{' .. (table_number - 1) .. '}\n' .. latex)
  end
end

function Figure(figure)
  if is_word and figure.caption.long and #figure.caption.long > 0 then
    figure_number = figure_number + 1
    figure.caption.long = numbered_caption(figure.caption.long, 'Figure', figure_number)
    return figure
  end
end

-- Before Pandoc 3, an implicit figure is a paragraph containing one image.
-- Keep its caption numbering consistent with the newer Figure representation.
function Para(paragraph)
  if not is_word or PANDOC_VERSION[1] >= 3 or #paragraph.content ~= 1 then return nil end
  local item = paragraph.content[1]
  if item.t == 'Image' and item.title:match('^fig:') then
    figure_number = figure_number + 1
    local blocks = numbered_caption({pandoc.Plain(item.caption)}, 'Figure', figure_number)
    item.caption = blocks[1].content
    return paragraph
  end
end

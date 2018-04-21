" Indents vims fold markers to the same indent level as the surrounding code
" Maintainer:   Michael Coleman
" Version:      0.1

if exists('g:loaded_indented_foldtext') || &cp 
  finish
endif
let g:loaded_indented_foldtext = 1

function! IndentedFoldText()

    function! s:getIndentAsString(lineNumFoldStart)
        " indent() takes a line number and returns an integer, e.g. 8
        let l:indentLevelAsInteger = indent(a:lineNumFoldStart)
        let l:indent = repeat(' ', l:indentLevelAsInteger)
        return l:indent
    endfunction

    function! s:getFoldMetaData(lineNumFirstFoldedLine, lineNumLastFoldedLine, foldLevelAsDashes)

        let l:dash_field = printf('%s', a:foldLevelAsDashes)

        let l:num_lines_folded = a:lineNumLastFoldedLine - a:lineNumFirstFoldedLine + 1
        let l:num_lines_folded_field = printf('%3s', l:num_lines_folded)

        let l:foldMetaData = l:dash_field . l:num_lines_folded_field . ' lines: ' 

        return l:foldMetaData
    endfunction

    function! s:getFirstLineContents(lineNumFirstFoldedLine)

        let l:line = getline(a:lineNumFirstFoldedLine)

        " Remove unwanted tokens out of the foldtext (text to appear in fold)
        " Vim's builtin foldtext() function trims comment markers, I want to
        " keep them so I know whether the fold contains comments or code!
        " TODO the \{\{\{  foldmarkers may need to be fixed up - need to use
        " it for a while and see how it behaves
        let l:line = substitute(l:line, '{{{\d\=\|\(^\s\+\)', '', 'g')
        " }}} this closes the fold which the \}\}\} above causes vim to start
        let l:line  =  substitute(l:line, '^\s\+', ' ', '')
        return l:line
    endfunction

    " these strings are used to store the major sections of the final
    " string to be returned and used for the foldtext
    let l:indent = s:getIndentAsString(v:foldstart)
    let l:fold_indicator_char = '+'
    let l:meta_data = s:getFoldMetaData(v:foldstart, v:foldend, v:folddashes)
    let l:first_line_contents = s:getFirstLineContents(v:foldstart)

    return l:indent . l:fold_indicator_char . l:meta_data . l:first_line_contents
endfunction


command! IndentedFoldText :setlocal foldtext=IndentedFoldText()
set foldtext=IndentedFoldText()

hi Folded ctermbg=none

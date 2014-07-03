" --------------------------------
" Add our plugin to the path
" --------------------------------
python import sys
python import vim
python sys.path.append(vim.eval('expand("<sfile>:h")'))

" --------------------------------
"  Function(s)
" --------------------------------
function! TemplateExample(pattern)
python << endOfPython

from pull_lines import pull_lines_example

# for n in range(5):
print(pull_lines_example(vim.eval('a:pattern')))

endOfPython
endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
command! -nargs=1 Example call TemplateExample(<args>)

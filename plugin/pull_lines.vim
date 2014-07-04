" --------------------------------
" Add our plugin to the path
" --------------------------------

python << EOF
import re
def getParameters():
  pattern = vim.eval('a:pattern')
  line1 = vim.eval('a:line1')
  line2 = vim.eval('a:line2')
  bang = vim.eval('a:bang')

  start, end = int(line1), int(line2)
  bufferRange = vim.current.buffer.range(start, end)
  return pattern, bufferRange, bang
EOF

" --------------------------------
"  Function(s)
" --------------------------------
function! PullLinesI(pattern, line1, line2, bang) range
python << endOfPython

def manualRelocation(lines):
  extracted = []
  residual = []
  cpattern = re.compile(pattern)
  ccol = vim.current.window.cursor[1]
  cline = vim.current.window.cursor[0]
  offset = 0
  start = vim.current.range.start
  for line in lines:
    if cpattern.search(line):
      if start <= cline:
        offset += 1
      extracted.append(line)
    else:
      residual.append(line)
    start += 1
  lines[:] = residual
  vim.current.buffer.append(extracted, cline-offset-1)
  vim.current.window.cursor = (cline-offset, ccol)

pattern, bufferRange, bang = getParameters()
manualRelocation(bufferRange)
endOfPython

endfunction

function! ExtractLinesI(pattern, line1, line2, bang) range
  python << endOfPython

def extractLines(lines):
  residual = []
  cpattern = re.compile(pattern)
  for line in lines:
    if cpattern.search(line):
      residual.append(line)
  lines[:] = residual

pattern, bufferRange, bang = getParameters()
extractLines(bufferRange)
endOfPython

endfunction


function! DeleteLinesI(pattern, line1, line2, bang) range
  python << endOfPython

def deleteLines(lines):
  extracted = []
  cpattern = re.compile(pattern)
  for line in lines:
    if cpattern.search(line) is None:
      extracted.append(line)
  lines[:] = extracted

pattern, bufferRange, bang = getParameters()
deleteLines(bufferRange)
endOfPython

endfunction

" --------------------------------
"  Expose our commands to the user
" --------------------------------
" command! -range=% -nargs=1 PullLines call PullLinesI("<args>", <line1>, <line2>)
command! -bang -range=% -nargs=1 DeleteLines call DeleteLinesI("<args>", <line1>, <line2>, "<bang>")
command! -bang -range=% -nargs=1 ExtractLines call ExtractLinesI("<args>", <line1>, <line2>, "<bang>")
command! -bang -range=% -nargs=1 PullLines call PullLinesI("<args>", <line1>, <line2>, "<bang>")

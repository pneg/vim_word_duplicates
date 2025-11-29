let s:duplicatesMatched = []

" Default highlight groups
if !hlexists('DuplicateWord')
  hi default link DuplicateWord SpellBad
end

function! word_duplicates#match_word(word)
  let l:buf = bufnr('%')
  let l:wordPattern = '\V\<' . escape(a:word, '\') . '\>'
  let l:wordMatches = matchbufline(l:buf, l:wordPattern, 1, '$')

  if len(l:wordMatches) > 1
    let l:id = matchadd('DuplicateWord', l:wordPattern)
    call add(s:duplicatesMatched, {'id': l:id, 'pattern': l:wordPattern })
  endif
endfunction

function! word_duplicates#check_under_cursor()
  let l:wordUnderCursor = expand("<cword>")
  call word_duplicates#match_word(wordUnderCursor)
endfunction

function! word_duplicates#check_behind_cursor()
  let l:savedPos = getpos('.')
  normal! b
  let l:wordBehindCursor = expand('<cword>')
  call setpos('.', savedPos)
  call word_duplicates#match_word(wordBehindCursor)
endfunction

function! word_duplicates#recheck_duplicates()
  let l:buf = bufnr('%')
  let l:index = 0
  for duplicate in s:duplicatesMatched
    let l:wordMatches = matchbufline(l:buf, duplicate.pattern, 1, '$')
    if len(l:wordMatches) <= 1
      call matchdelete(duplicate.id)
      call remove(s:duplicatesMatched, index)
      let l:index -= 1
    endif
    let l:index += 1
  endfor
endfunction

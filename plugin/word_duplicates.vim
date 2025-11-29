
if exists('g:loaded_vim_word_duplicates')
  finish
endif
let g:loaded_vim_word_duplicates = 1

augroup wordDuplicates
  au!
  au CursorMoved * call word_duplicates#check_under_cursor()
  au CursorMovedI * call word_duplicates#check_behind_cursor()
  au TextChanged * call word_duplicates#recheck_duplicates()
  au TextChangedI * call word_duplicates#recheck_duplicates()
augroup END

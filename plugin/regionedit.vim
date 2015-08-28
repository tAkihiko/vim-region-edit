" Region Edit
"
" Author: tAkihiko <pureodio1109@gmail.com>
" Licence: MIT
"

scriptencoding utf-8

command! -range=% -nargs=* RegionEdit call <SID>StartPatternRegionEdit(<line1>, <line2>, <q-args>)
command! EndRegionEdit call <SID>EndPatternRegionEdit()

function! s:StartPatternRegionEdit(begin, end, pat)
	if exists('b:RegionEdit')
		return
	endif

	if &mod != 0
		echohl Error
		echo "保存してください"
		echohl None
		return
	endif

	let l:line_list = []
	for l:lnum in range(a:begin, a:end)
		let l:line = getline(l:lnum)
		if match(l:line, a:pat) >= 0
			let l:line_list += [[l:lnum, l:line]]
		endif
	endfor

	let l:fname = expand('%')

	edit `=tempname()`

	for l:line_node in l:line_list
		call append(line('$'), l:line_node[1])
	endfor

	0 delete _

	let b:RegionEdit = l:fname
	let b:RegionEditList = l:line_list
	setlocal buftype=nowrite
endfunction

function! s:EndPatternRegionEdit()
	if  !exists('b:RegionEdit')
		echohl Error
		echo "編集中のものがありません"
		echohl None
		return
	endif

	let l:line_list = []
	for l:lnum in range(1, line('$'))
		let l:line_list += [getline(l:lnum)]
	endfor

	echo len(l:line_list)
	if len(b:RegionEditList) != len(l:line_list)
		echohl Error
		echo "行数がちがいます"
		echohl None
		return
	endif

	let l:line_prev_list = b:RegionEditList
	let l:fname = b:RegionEdit

	execute 'edit' l:fname
	setlocal buftype=

	let l:lcnt = 0
	for l:line in l:line_prev_list
		call setline(l:line[0], l:line_list[l:lcnt])
		let l:lcnt += 1
	endfor

endfunction

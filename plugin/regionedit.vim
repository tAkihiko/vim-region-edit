" Region Edit
"
" Author: tAkihiko <pureodio1109@gmail.com>
" Licence: MIT
"

scriptencoding utf-8

command! -range=% -nargs=* RegionEdit call <SID>StartPatternRegionEdit(<line1>, <line2>, <q-args>)
command! EndRegionEdit call <SID>EndRegionEdit()

function! s:StartPatternRegionEdit(begin, end, pat)
	if exists('b:RegionEditFile')
		return
	endif

	if &modified != 0
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
	let l:ft = &filetype

	edit `=tempname()`
	setlocal buftype=nowrite
	setlocal noswapfile
	file [Region Edit]
	let &filetype = l:ft

	for l:line_node in l:line_list
		call append(line('$'), l:line_node[1])
	endfor

	0 delete _

	let b:RegionEditFile = l:fname
	let b:RegionEditList = l:line_list

	if len(a:pat) > 0
		let b:RegionEditMode = 0
	else
		let b:RegionEditMode = 1
	endif
endfunction

function! s:EndRegionEdit()
	if  !exists('b:RegionEditFile') || !exists('b:RegionEditList') || !exists('b:RegionEditMode')
		echohl Error
		echo "編集中のものがありません"
		echohl None
		return
	endif

	let l:line_list = []
	for l:lnum in range(1, line('$'))
		let l:line_list += [getline(l:lnum)]
	endfor

	let l:line_prev_list = b:RegionEditList
	let l:fname = b:RegionEditFile

	if b:RegionEditMode == 0
		if len(b:RegionEditList) != len(l:line_list)
			echohl Error
			echo "行数がちがいます"
			echohl None
			return
		endif

		execute 'edit' l:fname
		setlocal buftype=

		let l:lcnt = 0
		for l:line in l:line_prev_list
			if l:line[1] != l:line_list[l:lcnt]
				call setline(l:line[0], l:line_list[l:lcnt])
			endif
			let l:lcnt += 1
		endfor

	elseif b:RegionEditMode == 1

		execute 'edit' l:fname
		setlocal buftype=

		let l:begin = l:line_prev_list[0][0]
		let l:end = l:line_prev_list[-1][0]
		
		for l:lcnt in l:line_prev_list
			execute l:begin "delete" "_"
		endfor

		for l:line in reverse(l:line_list)
			call append(l:begin - 1, l:line)
		endfor

	endif

endfunction

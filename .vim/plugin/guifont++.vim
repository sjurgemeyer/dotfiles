" Vim plugin for quickly changing GUI font size.
"
" Maintainer: Alexander Anderson <a.anderson@utoronto.ca>
"
" Description:
" This plugin defines key mappings to quickly make the GUI font larger or
" smaller. The default mappings are "+" to make the font larger by 1 point
" and "-" to make the font smaller by 1 point. The original font size can
" be restored with "=" key at any time. The mappings are user-configurable
" (see the installation section below).
"
" This plugin should work on Unix and Win32 but it will work only with
" certain patterns of 'guifont' option, namely:
"
"  - on Unix, 'guifont' should be set to the X Logical Font Description
"    (XLFD) name, for example:
"
"       set guifont=-*-lucidatypewriter-bold-*-*-*-15-*-*-*-*-*-*-*
"
"  - on Win32, 'guifont' should include 'hXX' font option, for example:
"
"       set guifont=Lucida_Console:h8:cANSI
"
" Please let me know if this is not good enough for you.
"
" Installation:
" Simply copy this plugin into your plugin directory. (See 'plugin' in the
" Vim User Manual.) Additionally, you may choose to override one of the
" following global variables, which are used by this plugin, in your vimrc
" file:
"
"  - guifontpp_size_increment         (default: 1)
"       The number of points by which to make the font size smaller or
"       larger.
"  - guifontpp_smaller_font_map       (default: "-")
"       LHS of the key mapping to make the font size smaller.
"  - guifontpp_larger_font_map        (default: "+")
"       LHS of the key mapping to make the font size larger.
"  - guifontpp_original_font_map      (default: "=")
"       LHS of the key mapping to restore the original font size.
"
" For example, you could have something like this in your vimrc file:
"   let guifontpp_size_increment=2
"   let guifontpp_smaller_font_map="<F10>"
"   let guifontpp_larger_font_map="<S-F10>"
"   let guifontpp_original_font_map="<C-F10>"
"
" Version: $Id: guifont++.vim,v 1.6 2003/03/20 14:00:16 alex Exp alex $

if exists("loaded_guifontpp") || !exists("&guifont")
    finish
endif
let loaded_guifontpp = 1

let s:guifontpp_size_increment = 1
let s:guifontpp_smaller_font_map = "-"
let s:guifontpp_larger_font_map = "+"
let s:guifontpp_original_font_map = "="

if exists("g:guifontpp_size_increment")
    let s:guifontpp_size_increment = g:guifontpp_size_increment
endif
if exists("g:guifontpp_smaller_font_map")
    let s:guifontpp_smaller_font_map = g:guifontpp_smaller_font_map
endif
if exists("g:guifontpp_larger_font_map")
    let s:guifontpp_larger_font_map = g:guifontpp_larger_font_map
endif
if exists("g:guifontpp_original_font_map")
    let s:guifontpp_original_font_map = g:guifontpp_original_font_map
endif

let s:decimalpat = '[1-9][0-9]*'
let s:fontpat_unix = '^\(\(-[^-]\+\)\{6}-\)\(' . s:decimalpat . '\)'
let s:fontpat_win32 = '\(:h\)\(' . s:decimalpat . '\)\(:\|,\|$\)'

fun! s:GetFontSize()
    if has("unix")
        let sizealmost = matchstr(&guifont, s:fontpat_unix)
        let size = matchstr(sizealmost, s:decimalpat . '$')
    elseif has("win32")
        let sizealmost = matchstr(&guifont, s:fontpat_win32)
        let size = matchstr(sizealmost, s:decimalpat)
    else
        echoerr "This works only with Unix or Win32 version of Vim"
        return
    endif
    if size == ""
        echoerr "Cannot match your 'guifont' to a known pattern"
    endif
    if !exists("s:originalFontSize")
        let s:originalFontSize = size
    endif
    return size
endfun

fun! s:SetFontSize(size)
    if has("unix")
        let guifont = substitute(&guifont, s:fontpat_unix,
                               \ '\1' . a:size, "")
    elseif has("win32")
        let guifont = substitute(&guifont, s:fontpat_win32, 
                               \ '\1' . a:size . '\3', "")
    endif
    let &guifont = guifont
endfun

fun! s:SetLargerFont()
    let size = s:GetFontSize()
    if size
        call s:SetFontSize(size + s:guifontpp_size_increment)
    endif
endfun

fun! s:SetSmallerFont()
    let size = s:GetFontSize()
    if size && size > 1
        call s:SetFontSize(size - s:guifontpp_size_increment)
    endif
endfun

fun! s:SetOriginalFont()
    if s:originalFontSize
        call s:SetFontSize(s:originalFontSize)
    else
        echoerr "Original font size is unknown"
    endif
endfun

let s:ms = "map <silent> "
exe s:ms . s:guifontpp_smaller_font_map  . " :call <SID>SetSmallerFont()<CR>"
exe s:ms . s:guifontpp_larger_font_map   . " :call <SID>SetLargerFont()<CR>"
exe s:ms . s:guifontpp_original_font_map . " :call <SID>SetOriginalFont()<CR>"

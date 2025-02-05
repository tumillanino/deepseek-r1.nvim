if exists('g:loaded_deepseek_r1')
  finish
endif
let g:loaded_deepseek_r1 = loaded_deepseek_r1
lua require('deepseek_r1').setup()

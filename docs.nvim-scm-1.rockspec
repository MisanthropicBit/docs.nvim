local _MODREV, _SPECREV = 'scm', '-1'
rockspec_format = "3.0"
package = 'nvim-dap'
version = _MODREV .. _SPECREV

description = {
  summary = 'Enhanced documentation and keywordprg for neovim',
  detailed = [[]],
  labels = {
    'neovim',
    'plugin',
    'documentation',
    'keywordprg',
  },
  homepage = 'https://github.com/MisanthropicBit/docs.nvim',
  license = 'BSD 3-Clause',
}

dependencies = {
  'lua == 5.1',
}

source = {
   url = 'git://github.com/MisanthropicBit/docs.nvim',
}

build = {
   type = 'builtin',
   copy_directories = {
     'doc',
     'plugin',
   },
}

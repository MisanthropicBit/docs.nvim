<div align="center">
  <br />
  <h1>docs.nvim</h1>
  <p><i>Enhanced documentation and keywordprg</i></p>
  <p>
    <img src="https://img.shields.io/badge/version-0.1.0-blue?style=flat-square" />
    <a href="https://luarocks.org/modules/MisanthropicBit/docs.nvim">
        <img src="https://img.shields.io/luarocks/v/MisanthropicBit/docs.nvim?logo=lua&color=purple" />
    </a>
    <a href="/.github/workflows/tests.yml">
        <img src="https://img.shields.io/github/actions/workflow/status/MisanthropicBit/docs.nvim/tests.yml?branch=master&style=flat-square" />
    </a>
    <a href="/LICENSE">
        <img src="https://img.shields.io/github/license/MisanthropicBit/docs.nvim?style=flat-square" />
    </a>
  </p>
  <br />
</div>

<!-- panvimdoc-ignore-start -->

<div align="center">

🚧 **This plugin is under development** 🚧

</div>

- [Features](#features)
- [Requirements](#requirements)
- [Installing](#installing)
- [Configuration](#configuration)
- [Builtin configurations](#builtin-sources)
- [Commands](#commands)
- [Contributing](#contributing)
- [FAQ](#faq)
- [Showcase](#showcase)

<!-- panvimdoc-ignore-end -->

## Features

* Multiple ways to open docs: url, builtin help, shell command etc.
* Treesitter support for word under cursor and injected languages.
* Support for fuzzy pickers for picking documentation sources.
* Lots of builtin support for existing documentation sources.
* Configurable fallbacks.

## Requirements

* Neovim 0.8.0+

## Installing

* **[vim-plug](https://github.com/junegunn/vim-plug)**

```vim
Plug 'MisanthropicBit/docs.nvim'
```

* **[packer.nvim](https://github.com/wbthomason/packer.nvim)**

```lua
use 'MisanthropicBit/docs.nvim'
```

You can use `docs.nvim` as your `keywordprg` option:

```lua
vim.cmd([[set keywordprg=:DocsCursor]])
```

## Configuration

If you are content with the defaults, you don't need to do anything. Otherwise,
you can call `docs.configure`. Defaults are shown below. Refer to the
[documentation](/doc/docs.txt) for more information.

```lua
docs.configure({
    builtins = true,
    picker = false,
    custom = {
        -- ...
    },
    fallback = configs.builtins.fallbacks.devdocs,
    open_url = function() end,
})
```

## Builtin sources

| Documentation Source | Type           | Languages              |
| :---------------     | :------------: | :--------------------: |
| bing                 | url            | all                    |
| chai                 | url            | javascript, typescript |
| devdocs              | url            | all*                   |
| duckduckgo           | url            | all                    |
| google               | url            | all                    |
| jest                 | url            | javascript, typescript |
| knex                 | url            | supported sql dialects |
| mocha                | url            | javascript, typescript |
| momentjs             | url            | javascript, typescript |
| mozilla              | url            | javascript             |
| npm                  | url            | javascript, typescript |
| pytest               | url            | python                 |
| react                | url            | javascript, typescript |
| sinon                | url            | javascript, typescript |

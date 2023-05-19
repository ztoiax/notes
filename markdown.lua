return {
    -- preview
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            -- call mkdp#util#install()
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown" },
    },

    { 
        "toppair/peek.nvim",
        build = function()
            vim.fn["deno task --quiet build:fast"]()
        end,
        ft = { "markdown" },
    },

    -- 自动生成目录
    {"mzlogin/vim-markdown-toc", ft = { "markdown" }},

    -- 快速插入markdown表格
    {"dhruvasagar/vim-table-mode", ft = { "markdown" }},

    -- 表格自动对齐
    {
        "masukomi/vim-markdown-folding",
        config = function ()
            vim.cmd([[
                function! s:isAtStartOfLine(mapping)
                    let text_before_cursor = getline('.')[0 : col('.')-1]
                    let mapping_pattern = '\V' . escape(a:mapping, '\')
                    let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
                    return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
                endfunction

                inoreabbrev <expr> <bar><bar>
                  \ <SID>isAtStartOfLine('\|\|') ?
                  \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'

                inoreabbrev <expr> __
                  \ <SID>isAtStartOfLine('__') ?
                  \ '<c-o>:silent! TableModeDisable<cr>' : '__'
            ]])
        end
    },
}

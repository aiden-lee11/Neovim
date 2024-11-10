-- Enable Vim's built-in menu navigation for LSP autocomplete
vim.lsp.handlers['textDocument/completion'] = vim.lsp.with(vim.lsp.handlers['textDocument/completion'], { isCompletionItemArray = true })

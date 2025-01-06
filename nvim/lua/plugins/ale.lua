return {
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_ruby_rubocop_auto_correct_all = 1

        g.ale_linters = {
            python = {'pylint'},
            javascript = {'eslint'},
        }
        
        g.ale_fixers = {
            javascript = { 'eslint' }
        }

        g.ale_linters = {
          javascript = {'eslint'},
          python = {'pylint'},
          html = {},
        }

        g.ale_fixers = {
          javascript = {'eslint'},
        }

        g.ale_fix_on_save = 1
    end
}


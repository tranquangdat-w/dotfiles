return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup{
        map_cr = true,
        map_complete = true
      }
    end
}

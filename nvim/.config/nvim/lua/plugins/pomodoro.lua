return {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },

    dependencies = {
        -- Optional, but highly recommended if you want to use the "Default" timer
        "rcarriga/nvim-notify",
        config = function()
            local play_sound = function(path, seconds)
                local home_dir = os.getenv("HOME")
                local sound_path = home_dir .. path
                vim.loop.spawn("mplayer", {
                    args = { sound_path },
                    detached = true,
                }, function()
                    print("Sound finished playing")
                end)

                vim.defer_fn(function()
                    vim.fn.system("pkill mplayer")
                    print("Sound stopped after 15 seconds")
                end, seconds)
            end
            local PrintNotifier = {}

            PrintNotifier.new = function(timer, opts)
              local self = setmetatable({}, { __index = PrintNotifier })
              self.timer = timer
              self.hidden = false
              self.opts = opts -- not used
              return self
            end

            PrintNotifier.start = function(self)
              print(string.format("Starting timer #%d, %s, for %ds", self.timer.id, self.timer.name, self.timer.time_limit))
            end

            PrintNotifier.tick = function(self, time_left)
              if not self.hidden then
                print(string.format("Timer #%d, %s, %ds remaining...", self.timer.id, self.timer.name, time_left))
              end
            end

            PrintNotifier.done = function(self)
              print(string.format("Timer #%d, %s, complete", self.timer.id, self.timer.name))
            end

            PrintNotifier.stop = function(self) end

            PrintNotifier.show = function(self)
              self.hidden = false
            end

            PrintNotifier.hide = function(self)
              self.hidden = true
            end
            require("notify").setup({
              init = PrintNotifier.new,
              background_colour = "#1e1e2e",
              on_open = function(notification)
                if notification then
                  play_sound("/.config/nvim/break.mp3", 15000)
                end
              end,
            })

            require("lualine").setup {
                sections = {
                    lualine_x = {
                        function()
                            local ok, pomo = pcall(require, "pomo")
                            if not ok then
                                return ""
                            end

                            local timer = pomo.get_first_to_finish()
                            if timer == nil then
                                return ""
                            end

                            return "󰄉 " .. tostring(timer)
                        end,
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
            }
        end,
    },
    opts = {
        work_time = 25,
        break_time = 5,
        long_break_time = 15,
        sessions = {
            pomodoro = {
                { name = "Work",        duration = "30m" },
                { name = "Short Break", duration = "7m" },
                { name = "Work",        duration = "25m" },
                { name = "Short Break", duration = "7m" },
                { name = "Work",        duration = "25m" },
                { name = "Long Break",  duration = "10m" },
            },
        },
    },
}


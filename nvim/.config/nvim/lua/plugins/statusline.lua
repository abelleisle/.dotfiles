local M = {}

M.config = function()
    local gle, gl = pcall(require, 'galaxyline')

    if not gle then
      return
    end

    local gls = gl.section
    gl.short_line_list = {'LuaTree','vista','dbui'}

    local colors = vim.g.colors
    if colors == nil then
      print("Error: StatusLine vim.g.colors are not set")
      return
    end

    local buffer_not_empty = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true end
      return false
    end

    local filename_and_parent = function()
        if buffer_not_empty() then
            -- return vim.fn.expand("%:p:h:t") .. "/" .. vim.fn.expand('%:t') .. " "
            local file = vim.fn.expand("%:.")
            local t = {}
            local entries = 0
            local sep = "/"
            for str in string.gmatch(file, "([^"..sep.."]+)") do
                table.insert(t, str)
                entries = entries + 1
            end

            local pr = ""
            for k,v in pairs(t) do
                if k > entries - 2 then
                    pr = pr .. "/" .. v
                else
                    pr = pr .. "/" .. v:sub(0,1)
                end
            end
            return pr:sub(2) .. " "
        end
        return ""
    end

    local checkwidth = function()
      local current_win = vim.fn.winnr();
      if current_win == -1 then
        current_win = 0
      end
      local squeeze_width  = vim.fn.winwidth(current_win) / 2
      if squeeze_width > 60 then
        return true
      end
      return false
    end

    local buffer_wide = function()
        if buffer_not_empty() then
            return checkwidth()
        end
        return false
    end

    gls.left[1] = {
      FirstElement = {
        provider = function() return '▋' end,
        highlight = {colors.blue,colors.grey0}
      },
    }
    gls.left[2] = {
      ViMode = {
        provider = function()
          local alias = {n = 'NORMAL',i = 'INSERT',c= 'COMMAND',v= 'VISUAL',V= 'VISUAL LINE', [''] = 'VISUAL BLOCK'}
          return alias[vim.fn.mode()]
        end,
        separator = '',
        separator_highlight = {colors.grey0,function()
          if not buffer_not_empty() then
            return colors.grey0
          end
          return colors.grey1
        end},
        highlight = {colors.yellow,colors.grey0,'bold'},
      },
    }
    gls.left[3] ={
      FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color,colors.grey1},
      },
    }
    gls.left[4] = {
      FileName = {
        --provider = {'FileName','FileSize'},
        provider = {
                filename_and_parent,
                'FileSize'
            },
        condition = buffer_not_empty,
        separator = '',
        separator_highlight = {colors.grey0,colors.grey1},
        highlight = {colors.magenta,colors.grey1}
      }
    }
    gls.left[5] = {
      GitIcon = {
        provider = function() return '  ' end,
        condition = buffer_wide,
        highlight = {colors.orange,colors.grey0},
      }
    }
    gls.left[6] = {
      GitBranch = {
        provider = function()
            if require("galaxyline.condition").check_git_workspace() then
                return require("galaxyline.providers.vcs").get_git_branch()
            else
                return 'N/A'
            end
        end,
        condition = buffer_wide,
        separator = ' ',
        separator_highlight = {colors.grey0, colors.grey0},
        highlight = {colors.grey2,colors.grey0},
      }
    }
    gls.left[7] = {
      DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.green,colors.grey0},
      }
    }
    gls.left[8] = {
      DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.orange,colors.grey0},
      }
    }
    gls.left[9] = {
      DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.red,colors.grey0},
      }
    }
    gls.left[10] = {
      LeftEnd = {
        provider = function() return '' end,
        separator = '',
        separator_highlight = {colors.grey0,colors.bg},
        highlight = {colors.grey0,colors.grey0}
      }
    }
    gls.left[11] = {
      DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.red,colors.bg}
      }
    }
    gls.left[12] = {
      Space = {
        provider = function () return ' ' end,
        highlight = {colors.bg, colors.bg}
      }
    }
    gls.left[13] = {
      DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = {colors.blue,colors.bg},
      }
    }
    gls.right[1]= {
      FileFormat = {
        provider = 'FileFormat',
        separator = ' ',
        separator_highlight = {colors.bg,colors.grey0},
        highlight = {colors.grey2,colors.grey0},
      }
    }
    gls.right[2] = {
      LineInfo = {
        provider = 'LineColumn',
        separator = ' | ',
        separator_highlight = {colors.grey1,colors.grey0},
        highlight = {colors.grey2,colors.grey0},
      },
    }
    gls.right[3] = {
      PerCent = {
        provider = 'LinePercent',
        separator = '',
        separator_highlight = {colors.grey1,colors.grey0},
        highlight = {colors.grey2,colors.grey1},
      }
    }
    gls.right[4] = {
      FileTypeName = {
          provider= 'FileTypeName',
          condition = buffer_not_empty,
          separator = ' ',
          separator_highlight = {colors.grey1,colors.grey0},
          highlight = {colors.blue,colors.grey0}
      }
    }
    gls.right[5] = {
      LastElement = {
        condition = buffer_not_empty,
        provider = function() return '▋' end,
        highlight = {colors.grey0,colors.grey0}
      },
    }

    gls.short_line_left[1] = {
      SmallFirst = {
        provider = function() return '▋' end,
        highlight = {colors.red,colors.grey0}
      }
    }

    gls.short_line_left[2] = {
      SmallFileName = {
        condition = buffer_not_empty,
        provider = filename_and_parent,
        separator = '',
        separator_highlight = {colors.grey0,colors.bg},
        highlight = {colors.grey2,colors.grey0}
      }
    }

    gls.short_line_right[1] = {
      SmallFileTypeName = {
        provider= 'FileTypeName',
        condition = buffer_not_empty,
        separator = '█',
        separator_highlight = {colors.grey0,colors.bg},
        highlight = {colors.red,colors.grey0}
      }
    }

    gls.short_line_right[2] = {
      SmallLastElement = {
        condition = buffer_not_empty,
        provider = function() return '▋' end,
        highlight = {colors.grey0,colors.grey0}
      },
    }

end
return M

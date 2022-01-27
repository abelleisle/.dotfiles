local M = {}

M.config = function()
    local gl = require('galaxyline')
    local gls = gl.section
    gl.short_line_list = {'LuaTree','vista','dbui'}

    local colors = {
      bg = '#1d2021',
      yellow = '#fabd2f',
      cyan = '#008080',
      darkblue = '#504945',
      green = '#afd700',
      orange = '#FF8800',
      purple = '#3c3836',
      magenta = '#d16d9e',
      grey = '#c0c0c0',
      blue = '#0087d7',
      red = '#ec5f67'
    }

    local buffer_not_empty = function()
      if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
        return true end
      return false
    end

    gls.left[1] = {
      FirstElement = {
        provider = function() return '▋' end,
        highlight = {colors.blue,colors.purple}
      },
    }
    gls.left[2] = {
      ViMode = {
        provider = function()
          local alias = {n = 'NORMAL',i = 'INSERT',c= 'COMMAND',v= 'VISUAL',V= 'VISUAL LINE', [''] = 'VISUAL BLOCK'}
          return alias[vim.fn.mode()]
        end,
        separator = '',
        separator_highlight = {colors.purple,function()
          if not buffer_not_empty() then
            return colors.purple
          end
          return colors.darkblue
        end},
        highlight = {colors.yellow,colors.purple,'bold'},
      },
    }
    gls.left[3] ={
      FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color,colors.darkblue},
      },
    }
    gls.left[4] = {
      FileName = {
        provider = {'FileName','FileSize'},
        condition = buffer_not_empty,
        separator = '',
        separator_highlight = {colors.purple,colors.darkblue},
        highlight = {colors.magenta,colors.darkblue}
      }
    }

    gls.left[5] = {
      GitIcon = {
        provider = function() return '  ' end,
        condition = buffer_not_empty,
        highlight = {colors.orange,colors.purple},
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
        condition = buffer_not_empty,
        separator = ' ',
        separator_highlight = {colors.purple, colors.purple},
        highlight = {colors.grey,colors.purple},
      }
    }

    local checkwidth = function()
      local squeeze_width  = vim.fn.winwidth(0) / 2
      if squeeze_width > 40 then
        return true
      end
      return false
    end

    gls.left[7] = {
      DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.green,colors.purple},
      }
    }
    gls.left[8] = {
      DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.orange,colors.purple},
      }
    }
    gls.left[9] = {
      DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = ' ',
        highlight = {colors.red,colors.purple},
      }
    }
    gls.left[10] = {
      LeftEnd = {
        provider = function() return '' end,
        separator = '',
        separator_highlight = {colors.purple,colors.bg},
        highlight = {colors.purple,colors.purple}
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
        separator_highlight = {colors.bg,colors.purple},
        highlight = {colors.grey,colors.purple},
      }
    }
    gls.right[2] = {
      LineInfo = {
        provider = 'LineColumn',
        separator = ' | ',
        separator_highlight = {colors.darkblue,colors.purple},
        highlight = {colors.grey,colors.purple},
      },
    }
    gls.right[3] = {
      PerCent = {
        provider = 'LinePercent',
        separator = '',
        separator_highlight = {colors.darkblue,colors.purple},
        highlight = {colors.grey,colors.darkblue},
      }
    }

    gls.short_line_left[1] = {
      SmallFirst = {
        provider = function() return '▋' end,
        highlight = {colors.red,colors.purple}
      }
    }

    gls.short_line_left[2] = {
      SmallFileName = {
        provider = 'FileName',
        separator = '',
        separator_highlight = {colors.purple,colors.bg},
        highlight = {colors.grey,colors.purple}
      }
    }

    gls.short_line_right[1] = {
      FileTypeName = {
        provider= 'FileTypeName',
        condition = buffer_not_empty,
        separator = '',
        separator_highlight = {colors.purple,colors.bg},
        highlight = {colors.grey,colors.purple}
      }
    }

end
return M

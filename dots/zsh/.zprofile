source ~/.profile

# Something on my work laptop automatically inserts this `eval` line via a
# cron job. If the line is removed it will be reinserted. Keeping it
# commented out satisfies the presence check while preventing it from
# getting run.
#
# 1. These dotfiles are used on both Linux and MacOS
# 2. On MacOS, both x86_64 and arm64 homebrew instances are maintained
#    and this will cause the arm64 instance to get activated, even if we're
#    inside an x86_64 terminal.
# eval "$(/opt/homebrew/bin/brew shellenv)"

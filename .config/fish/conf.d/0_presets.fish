if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
set -g theme_color_scheme gruvbox
set -g theme_display_hg no
set -g theme_display_hostname yes
set -g theme_display_ruby no
set -g theme_nerd_fonts yes

set -g LSB_SYSTEM (uname -s)

# exclude ls, df
set -g grc_plugin_execs cat cvs diff dig gcc g++ ifconfig make mount mtr netstat ping ps tail traceroute wdiff

# For the AWS fucntions
set -g AWS_REGION_SEARCH "us-west-2" "us-east-2" "us-east-1"

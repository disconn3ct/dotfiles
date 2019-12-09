if test "$LSB_SYSTEM" = "Darwin"
    function showdesktop --description 'alias showdesktop=defaults write com.apple.finder CreateDesktop -bool true ; and killall Finder'
        defaults write com.apple.finder CreateDesktop -bool true
        and killall Finder $argv
    end
end
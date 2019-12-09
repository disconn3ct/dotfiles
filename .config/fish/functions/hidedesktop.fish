if test "$LSB_SYSTEM" = "Darwin"
    function hidedesktop --description 'alias hidedesktop=defaults write com.apple.finder CreateDesktop -bool false ; and killall Finder'
        defaults write com.apple.finder CreateDesktop -bool false
        and killall Finder
    end
end
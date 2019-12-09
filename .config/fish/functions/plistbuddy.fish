if test -x /usr/libexec/PlistBuddy
    function plistbuddy --description 'alias plistbuddy=/usr/libexec/PlistBuddy'
        /usr/libexec/PlistBuddy $argv

    end
end
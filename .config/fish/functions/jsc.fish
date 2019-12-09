if [ -x /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc ]
    function jsc --description 'alias jsc=/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
        /System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc $argv
    end
end

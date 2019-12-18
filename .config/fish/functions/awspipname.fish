function awspipname
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck awspipnamer "$argv[1]" "$region"
            and return
        end
    end
end

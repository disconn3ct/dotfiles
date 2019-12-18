function awspip
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck awspipr "$argv[1]" "$region"
            and return
        end
    end
end

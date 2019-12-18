function awsip --description "Get an IP address (default regions, multiple addresses possible)"
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            # echo "Searching $region for $srch"
            _awsoutcheck awsipr "$srch" "$region"
            and return
        end
    end
end

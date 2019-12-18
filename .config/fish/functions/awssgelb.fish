function awssgelb --description "List elbs based on SG ID"
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck aws elb describe-load-balancers --load-balancer-name "$argv[1]" --output text --query "LoadBalancerDescriptions[].Tags[?Key=='SecurityGroups'].Value | [0]]"
            and return
        end
    end
end

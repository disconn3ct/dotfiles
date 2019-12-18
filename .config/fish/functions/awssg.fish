function awssg --description "List instances based on SG ID"
    for srch in $argv
        for region in $AWS_REGION_SEARCH
            _awsoutcheck aws ec2 describe-instances --region "$region" --filter "Name=instance.group-id,Values=$argv[1]" --output text --query "Reservations[].Instances[].[ Tags[?Key=='Name'].Value | [0], PublicIpAddress ]"
            and return
        end
    end
end
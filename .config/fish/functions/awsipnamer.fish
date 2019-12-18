function awsipnamer --description "Get IP and name (with region)"
    aws ec2 describe-instances --region "$argv[2]" --filter "Name=tag:Name,Values=*$argv[1]*" --output text --query "Reservations[].Instances[].[ Tags[?Key=='Name'].Value | [0], PublicIpAddress ]"
end
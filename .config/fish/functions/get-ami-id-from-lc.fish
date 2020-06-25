function get-ami-id-from-lc
  set LCN (get-active-lc $argv[1])
  if test -z "$LCN"
    set LCN (get-active-lc "$argv[1]-$PROFILE")
    if test -z "$LCN"
      echo ""
      return 1
    end
  end
  aws --profile "$PROFILE" --region "$REGION" autoscaling describe-launch-configurations --launch-configuration-names "$LCN" --query "LaunchConfigurations[].ImageId" --output text
end


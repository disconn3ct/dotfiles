function get-active-lc
  aws --profile "$PROFILE" --region "$REGION" autoscaling describe-auto-scaling-groups --auto-scaling-group-names "$argv[1]" --query "AutoScalingGroups[].LaunchConfigurationName" --output text
end

function fluxreset
  flux suspend $argv ; and \
  sleep 5 ; and \
  flux resume $argv
  end

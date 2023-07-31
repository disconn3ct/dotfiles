function turingsetpower
  curl -sSl --request POST "http://10.0.16.200/api/bmc?opt=set&type=power&$argv"
end

function turingon
  turingsetpower ( for node in $argv
    echo -n "node$node=1&"
  end
  )
end

function turingoff
  turingsetpower ( for node in $argv
    echo -n "node$node=0&"
  end
  )
end

function turingpower
  curl -sSl "http://10.0.16.200/api/bmc?opt=get&type=power"
end

function turingreboot
  turingpower; or exit
  turingoff $argv; or exit
  turingpower; or exit
  sleep 5; or exit
  turingon $argv; or exit
  turingpower; or exit
end


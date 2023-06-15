function turingsetpower
  curl --location --request POST "http://10.0.16.200/api/bmc?opt=set&type=power&$argv" | jq .
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
  curl --location "http://10.0.16.200/api/bmc?opt=get&type=power" | jq .
end

function _awsoutcheck
    set outp ($argv)
    test -n "$outp"
    and begin
        echo "$outp"
        return 0
    end
    return 1
end
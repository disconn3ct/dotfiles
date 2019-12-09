begin
    which -s hd
    or which -s hexdump
end
and function hd
    hexdump -C $argv
end

NetAddr.new(Pipe.new("ifconfig en0 | grep \"inet \" | awk '{print $2}'" , "r").getLine, NetAddr.langPort);




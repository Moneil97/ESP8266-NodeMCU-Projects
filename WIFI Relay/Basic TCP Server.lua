
gpio.mode(3, gpio.OUTPUT)

server=net.createServer(net.TCP, 4000)

server:listen(1336,function(c)
      c:on("receive", function(c, pl) 
        print(pl)
         if (pl == "ON") then
            gpio.write(3, gpio.HIGH)
        elseif (pl == "OFF") then
            gpio.write(3, gpio.LOW)
         end
      end)
      c:send("hello world")
    end)
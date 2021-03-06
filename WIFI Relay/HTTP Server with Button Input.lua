
gpio.mode(3, gpio.OUTPUT)
gpio.mode(4, gpio.INPUT)
gpio.write(3, gpio.LOW)
current = 0;

server=net.createServer(net.TCP, 4000)
server:listen(1336,function(conn) 
    conn:on("receive",function(conn,payload)
    --print("Payload:") 
    --print(payload) 
    --print("Parsed:")
    i, j = string.find(payload, "control")
    --print(i,j)

    if i ~= nil then
        command = string.sub(payload, i+8, j+4)
        --print(command)
        
        if command == "ON" then
            gpio.write(3, gpio.HIGH)
            current = 1
        elseif command == "OFF" then
            gpio.write(3, gpio.LOW)
            current = 0
        end
    end

    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n')
    conn:send('<html>\n')
    conn:send('<head><meta  content="text/html; charset=utf-8">\n')
    conn:send('<title>ESP8266 Outlet Controller</title></head>\n')
    conn:send('<body><h1>Outlet Control 0</h1>\n')
    conn:send('<form action="" method="POST">\n')
    conn:send('<input type="submit" name="control" value="ON" style="height:50px; width:50px">\n')
    conn:send('<input type="submit" name="control" value="OFF" style="height:50px; width:50px">\n')
    conn:send('</body></html>\n')
    conn:on("sent", function(conn) conn:close() end)
    end) 
end)

--print("server setup")

last = 1;

tmr.alarm(0, 300, 1, function() 

    if gpio.read(4) ~= last then
        if last == 1 then
            if current == 1 then
                gpio.write(3, gpio.LOW)
                current = 0
            else
                gpio.write(3, gpio.HIGH)
                current = 1
            end
            last = 0
        else
            last = 1
        end
    end     
end )
    
--print("done")
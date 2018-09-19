
local messaging = {
  client_id = "ig haxxor",
  server_address = "paste",
  port = 1883,
  user = "mqtt",
  password = "mqtt"
}

function messaging.init()
  local client = mqtt.Client(messaging.client_id, 120, messaging.user, messaging.password)
  client:lwt("/lwt", "offline", 0, 0)

  client:on("connect", function(client) print ("mqtt connected") end)
  client:on("offline", function(client) print ("mqtt offline") end)
  client:on("message", messaging.on_message)

  client:connect(messaging.server_address, messaging.port, 0, messaging.connected, messaging.connection_failed)

  messaging.client = client
end

function messaging.on_message(client, topic, data)
  print(topic .. ":" ) 
  if data ~= nil then
    print(data)
  end
end

function messaging.connected(client)
  print("connected to mqtt broker")
  -- subscribe topic with qos = 0
  client:subscribe("/topic", 0, function(client) print("subscribe success") end)
  -- publish a message with data = hello, QoS = 0, retain = 0
  client:publish("/topic", "hello", 0, 0, function(client) print("sent") end)
end

function messaging.connection_failed(client, reason)
  print("failed to connect " .. reason)
end

return messaging.init()

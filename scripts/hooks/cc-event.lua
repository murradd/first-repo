local action = event:getHeader("CC-Action")
local caller_id_number = event:getHeader("CC-Member-CID-Number")
local uuid = event:getHeader("CC-Member-Session-UUID")
local agentUuid = event:getHeader("CC-Agent-UUID")

if action == "bridge-agent-start" then
   local agent = event:getHeader("CC-Agent")
   local api = freeswitch.API()
   local targetNumber = api:executeString("uuid_getvar " .. uuid .. " " .. "sip_h_X-Target-Number")
   local targetNumberName = api:executeString("uuid_getvar " .. uuid .. " " .. "sip_h_X-Target-Number-Name")
   local targetQueueName = api:executeString("uuid_getvar " .. uuid .. " " .. "sip_h_X-Target-Queue-Name")
   local sipCallId = api:executeString("uuid_getvar " .. agentUuid .. " " .. "sip_call_id")
   local msg = "system:event:" .. action .. ":uuid=" .. uuid .. ";call_id=".. sipCallId .. ";caller_id_number=" .. caller_id_number .. ";target_number=" .. targetNumber .. ";target_number_name=" .. targetNumberName .. ";target_queue_name=" .. targetQueueName
   api:executeString("chat sip|server|internal/" .. agent .."|" .. msg)
end

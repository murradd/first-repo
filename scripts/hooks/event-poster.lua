local api = freeswitch.API()
api:executeString("bgapi curl http://10.50.3.112/xmlcurl/freeswitch-event headers post " .. event:serialize())

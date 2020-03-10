-- callcenter-announce.lua
-- Arguments are, in order: caller uuid, queue_name, announce_interval, announce_message, delay_start_interval, delay_message.

function explode(div,str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    return arr
end

function index_of(t,val)
    for k,v in ipairs(t) do
        if v == val then return k end
    end
end

local function isempty(s)
  return s == nil or s == ''
end

api = freeswitch.API()
caller_uuid = argv[1]
queue_name = argv[2]
announce_interval = argv[3]
announce_message = argv[4]
delay_start_interval = argv[5]
delay_message = argv[6]

if caller_uuid == nil or queue_name == nil then
    return
end
while (true) do
    -- Pause between announcements
    freeswitch.msleep(tonumber(announce_interval) * 1000)
    members = api:executeString("callcenter_config queue list members "..queue_name)
    line_ix = 1
    column_titles = {}
    score_index = 0

    exists = false

    for line in members:gmatch("[^\r\n]+") do

        if line_ix == 1 then
            column_titles = explode("|", line)
            score_index = index_of(column_titles, 'score')
        end

        if (string.find(line, "Trying") ~= nil or string.find(line, "Waiting") ~= nil) then
            -- Members have a position when their state is Waiting or Trying

            entry_fields = explode("|", line)
            score = entry_fields[score_index]

            message_to_play = ''

            if isempty(announce_message) ~= true then
                message_to_play = announce_message
            end

            if isempty(delay_message) ~= true and tonumber(score) >= tonumber(delay_start_interval) then
                message_to_play = delay_message
            end

            if isempty(message_to_play) == false then
                api:executeString("uuid_broadcast "..caller_uuid.." "..message_to_play.." aleg")
            end

            exists = true
        end

        line_ix = line_ix + 1
    end
    -- If member was not found in queue, or it's status is Aborted - terminate script
    if exists == false then
        freeswitch.consoleLog("info", "Exiting\n")
        return
    end
end

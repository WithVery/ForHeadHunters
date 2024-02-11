local utils = require("scripts.t2utils");
local t2s = require("scripts.t2settings");

local uname = utils.getUsernameFromHeader(ngx.req.get_headers()['Authorization'])

-- ngx.log(ngx.ERR, "uname:", uname)
-- ngx.log(ngx.ERR, "client ip:", ngx.var.remote_addr)
-- ngx.log(ngx.ERR, "channel:", ngx.var.arg_c)
-- ngx.log(ngx.ERR, "IDs:", ngx.var.arg_id)

if (uname == "") or (ngx.var.arg_c == nil) or (ngx.var.arg_id == nil) then
	-- ngx.log(ngx.ERR, "failed");
	-- ngx.log(ngx.ERR, uname);
	-- ngx.log(ngx.ERR, ngx.var.arg_c);
	-- ngx.log(ngx.ERR, ngx.var.arg_id);
	return
end

ngx.req.read_body()
local cmd = ngx.req.get_body_data()

utils.logWebAction(uname, ngx.var.remote_addr, ngx.var.arg_c, ngx.var.arg_id, cmd)

-- process command to add parameters "reloadvideotriggers" 
local lc = utils.split(cmd, " ")
--ngx.log(ngx.ERR, "lc[1]: ", lc[1])
--ngx.log(ngx.ERR, "lc[2]: ", lc[2])

if lc[2] == "reloadvideotriggers" then 
	cmd = cmd .. " " .. t2s.RootDataFolder
	--ngx.log(ngx.ERR, "cmd=> ", cmd)
end

-- ngx.log(ngx.ERR, "cmd: ", cmd)
local gul = ngx.shared.g_uservskeyslist

local lg, lf = gul:get(uname)
-- ngx.log(ngx.ERR, "lg: ", lg)
-- ngx.log(ngx.ERR, "lf: ", lf)

if lg == nil then
	utils.pullKeysForUser(uname)
	lg, lf = gul:get(uname)
	if lg == nil then
		return
	end
end

-- ngx.log(ngx.ERR, "id: ", ngx.var.arg_id)
if ngx.var.arg_id == nil then
	ngx.log(ngx.ERR, "No keys")
	return
end

-- requested keys 
local t_ids = utils.splitKeys(ngx.var.arg_id)
local t_keys = utils.splitKeys(lg)
-- ngx.log(ngx.ERR, "lg: ", cjson.encode(t_keys))

local guk = ngx.shared.g_userkeys

-- get correct current date
local ct = os.time()
-- ngx.log(ngx.ERR, "ct: ", os.date("%Y", ct)..os.date("%m", ct)..os.date("%d", ct)..os.date("%H", ct)..os.date("%M", ct)..os.date("%S", ct))

ngx.log(ngx.ERR, "[", ngx.var.arg_c, "]=>", cmd)

local cd = os.time({year=os.date("%Y", ct), month = os.date("%m", ct), day = os.date("%d", ct), hour = 6})
-- ngx.log(ngx.ERR, "cd: ", os.date("%Y", cd)..os.date("%m", cd)..os.date("%d", cd)..os.date("%H", cd)..os.date("%M", cd)..os.date("%S", cd))

local curdate = ""
if ct < cd then 
	cd = os.time({year=os.date("%Y", ct), month = os.date("%m", ct), day = os.date("%d", ct) - 1, hour = 0})
end

curdate = os.date("%Y", cd)..os.date("%m", cd)..os.date("%d", cd)
-- ngx.log(ngx.ERR, "=> ", curdate)
-- get correct current date

for j = 1, #t_ids do	
	local cid = t_ids[j]
	--ngx.log(ngx.ERR, "cid[", j, "]: ", cid)
	for i = 1, #t_keys do
		local kkey = t_keys[i]
		if kkey == cid and type(kkey) ~= "userdata" then
			--ngx.log(ngx.ERR, "kkey[", i, "]: ", kkey)
-- new version with date/time parsing
			local cmd1 = cmd
			local tc = utils.split(cmd1, " ")
			if tc[2] == "startplaybackfromtime" then
				local blocktime = tc[3]
				-- ngx.log(ngx.ERR, "=> ", ngx.var.arg_c)
				-- ngx.log(ngx.ERR, "=> ", kkey)
				ngx.log(ngx.ERR, "=> ", blocktime)
				local tt = utils.split(blocktime, ":")
				ngx.log(ngx.ERR, "=> ", tt[1], ":", tt[2], ":", tt[3])

				local curtime = os.time()
				ngx.log(ngx.ERR, "=> ", curtime)
				--local curtimeT = os.date()
				local temp = os.date("*t", curtime)
				if temp.hour < 6 then
					temp.day = temp.day - 1
					ngx.log(ngx.ERR, "day=> ", temp.day)
				end
				
				local curday = 0
				if utils.blockIsActive(curdate, ngx.var.arg_c, kkey, blocktime) then
					if (kkey == "G2864") or (kkey == "G3039") or (kkey == "G3042") then
					
						local tt = utils.split(blocktime, ":")
						local ttm = string.format("%02d", (tonumber(tt[1]) - 1))..":"..tt[2]..":"..tt[3]
						blocktime = ttm
						cmd1 = tc[1].." "..tc[2].." ".. blocktime
							
						--temp.hour = temp.hour + 5
						curday = os.time{year=temp.year, month=temp.month, day=temp.day, hour=tt[1] + 5, min=tt[2], sec=tt[3]}						
					else 
						--temp.hour = temp.hour + 6
						curday = os.time{year=temp.year, month=temp.month, day=temp.day, hour=tt[1] + 6, min=tt[2], sec=tt[3]}						
					end
					--local ft = utils.UnixTimeToFileTimeString(os.time{year=temp.year, month=temp.month, day=temp.day, hour=temp.hour, min=temp.min, sec=temp.sec})
					local ft = utils.UnixTimeToFileTimeString(curday)
					cmd1 = tc[1].." "..tc[2].." ".. ft.." 1"
					ngx.log(ngx.ERR, "[", kkey, "]=>", cmd1)
					
					utils.queueCmd(kkey, cmd1)
					-- break
				end
			else
				ngx.log(ngx.ERR, "[", kkey, "]=>", cmd1)
				utils.queueCmd(kkey, cmd1)
			end
-- new version with date/time parsing - end of
		end
	end
end

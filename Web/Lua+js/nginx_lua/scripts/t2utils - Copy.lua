local t2utils = {};

local t2s = require("scripts.t2settings")

function t2utils.queueBcastChannelCmd(username, channel, cmd)
	if (user == "") or (cmd == "") then
		return
	end

	-- ngx.log(ngx.ERR, "username: ", username)
	-- ngx.log(ngx.ERR, "channel: ", channel)
	-- ngx.log(ngx.ERR, "cmd: ", cmd)

	local gul = ngx.shared.g_uservskeyslist

	local lg, lf = gul:get(username)
	-- ngx.log(ngx.ERR, "lg: ", lg)
	-- ngx.log(ngx.ERR, "lf: ", lf)
	if lg == nil then
		t2utils.pullKeysForUser(username)
		lg, lf = gul:get(uname)
		if lg == nil then
			return
		end
	end

	-- ngx.log(ngx.ERR, "lg: ", lg)

	local t_keys = t2utils.splitKeys(lg)
	local keyfnd = true

	local guk = ngx.shared.g_userkeys
		
	for i = 1, #t_keys do
		local kkey = t_keys[i]
		if kkey ~= nil and type(kkey) ~= "userdata" then
			-- ngx.log(ngx.ERR, "kkey[", i, "]: ", kkey, ">",  channel.."  "..cmd)
			t2utils.queueCmd(kkey, channel.."  "..cmd)
		end
		-- if kval ~= nil and type(kval) ~= "userdata" then
			-- local lkey = user .. "=" .. kval
			-- local lg, lf = guk:get(lkey)
			-- if lg == nil then
				-- keyfnd = false
				-- break
			-- end
		-- else
			-- ngx.log(ngx.ERR, "malformed request => ", kval)
			-- keyfnd = false
			-- break
		-- end
	end
end

function t2utils.loadSchedDataInfo(sid)
	local scheddata = {}
	for cn = 1, 4, 1 do
		scheddata[tostring(cn)] = {}
		datedata = {}
		for i = 0, 1, 1 do
			local curt = os.time({year=os.date("%Y", ct), month = os.date("%m", ct), day = os.date("%d", ct) + i})
			--local curt = os.time({year=y, month = m, day = d)
			--local cfn = "txt_"..cn.."_"..os.date("%Y_%m_%d", curt)..".txt"
			-- local lpath = t2s.RootDataFolder.."\\Stations\\"..sid.."\\txt\\"..cfn
			local st = os.date("%d/%m/%Y", curt)
			
			-- local sjd = datedata[st];
			-- local cdt = {}
			-- if sjd ~= nil then
				-- cdt = cjson.decode(sjd)
			-- end
			
			-- scheddata[cn] = {}
			local sddj = t2utils.loadSchedData(sid, cn, os.date("%Y", curt), os.date("%m", curt), os.date("%d", curt))
			
			-- cdt[st] = sddj
			-- sjd = cjson.encode(cdt)
			-- -- scheddata[cn] = sjd
			-- datedata[st] = sdj
			
			--datedata[st] = sddj
			datedata[tostring(i)] = sddj
			
			--ngx.log(ngx.ERR, sddj)
			-- scheddata[cn][ct] = sddj
		end
		-- ngx.log(ngx.ERR, cjson.encode(datedata))
		scheddata[tostring(cn)] = cjson.encode(datedata)
	end
	-- ngx.log(ngx.ERR, cjson.encode(scheddata))
	return cjson.encode(scheddata)
end

function t2utils.loadSchedData(sid, cn, y, m, d) 
	local schedchanneldata = {}
	-- ngx.log(ngx.ERR, "sid:", sid)
	-- ngx.log(ngx.ERR, cn)
	-- ngx.log(ngx.ERR, y)
	-- ngx.log(ngx.ERR, m)
	-- ngx.log(ngx.ERR, d)

	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok

	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	db:set_timeout(2000)
	ok, err, errno, sqlstate = db:connect{
		host     = t2s.MysqlHost,
		port     = t2s.MysqlPort,
		database = t2s.MysqlDBName,
		user     = t2s.MysqlLogin,
		password = t2s.MysqlPassword
	}

	if not ok then
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
		ngx.exit(500)
	end

	-- set up encode for connection
	--local query = "SET CHARSET cp1251"
	local query = "SET CHARSET utf8"
	res, err, errno, sqlstate = db:query(query)
	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return ""
	end


	--local curt = os.time({year=os.date("%Y", ct), month = os.date("%m", ct), day = os.date("%d", ct) + i})
	local curt = os.time({year=y, month = m, day = d})
	local cfn = "txt_"..cn.."_"..os.date("%Y_%m_%d", curt)..".txt"
	local lpath = t2s.RootDataFolder.."\\Stations\\"..sid.."\\txt\\"..cfn
	local st = os.date("%d/%m/%Y", curt)
	
	-- ngx.log(ngx.ERR, st)
	-- ngx.log(ngx.ERR, cjson.encode(schedchanneldata))
	-- ngx.log(ngx.ERR, lpath)
	
	-- txt section
	if t2utils.file_exists(lpath) then
		--ngx.log(ngx.ERR, lpath)
		-- local sjd = schedchanneldata[st];
		-- local cdt = {}
		-- if sjd ~= nil then
			-- cdt = cjson.decode(sjd)
		-- end
		-- cdt["txt"] = 1
		-- sjd = cjson.encode(cdt)
		-- schedchanneldata[st] = sjd
		
		schedchanneldata["txt"] = 1
	end
	-- txt section - end of
		
	-- tvb section
	local resj = ""
	query = 'SELECT log_time AS lt,action_type AS et,info AS inf FROM `log` WHERE station="%s" and action_code=100 and sday = "%s-%s-%s" and channel=%d ORDER BY log_time DESC LIMIT 1'
	query = string.format(query, sid, os.date("%Y", curt), os.date("%m", curt), os.date("%d", curt), cn);
	--ngx.log(ngx.ERR, ":->", query)
	res, err, errno, sqlstate = db:query(query)
	if res then
		resj = cjson.encode(res)
	else
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
		ngx.exit(500)
	end
	
	if (resj ~= "") and (resj ~= "{}") then 
		-- local sjd = schedchanneldata[st];
		-- local cdt = {}
		-- if sjd ~= nil then
			-- cdt = cjson.decode(sjd)
		-- end
		-- cdt["tvb"] = resj
		-- sjd = cjson.encode(cdt)
		-- schedchanneldata[st] = sjd
		schedchanneldata["tvb"] = resj
	end
	-- tvb section - end of
	
	-- ads section
	local resj = ""
	query = 'SELECT log_time AS lt,action_type AS et,info AS inf FROM `log` WHERE station="%s" and action_code=101 and sday = "%s-%s-%s" and channel=%d ORDER BY log_time DESC LIMIT 1'
	query = string.format(query, sid, os.date("%Y", curt), os.date("%m", curt), os.date("%d", curt), cn);
	res, err, errno, sqlstate = db:query(query)
	if res then
		resj = cjson.encode(res)
	else
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
		ngx.exit(500)
	end
	
	if (resj ~= "") and (resj ~= "{}") then 
		-- local sjd = schedchanneldata[st];
		-- local cdt = {}
		-- if sjd ~= nil then
			-- cdt = cjson.decode(sjd)
		-- end
		-- cdt["ads"] = resj
		-- sjd = cjson.encode(cdt)
		-- schedchanneldata[st] = sjd
		
		schedchanneldata["ads"] = resj
	end
	-- ads section - end of
	
	-- ngx.log(ngx.ERR, cjson.encode(schedchanneldata))
	
	return cjson.encode(schedchanneldata)
end


function t2utils.queueCmd(id, cmd)
	local globalcmd = ngx.shared.globalcmd
	-- ngx.log(ngx.ERR, "[", id, "] cmd=", cmd)
	local oldcmd = globalcmd:get(id)
	if (oldcmd and not(oldcmd == '')) then
		-- push cmd to stack to be sent to the remote station
		globalcmd:set(id, (oldcmd .. '\r\n') .. cmd);
	else
		globalcmd:set(id, cmd)
	end
end

function t2utils.file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function t2utils.lines_from_file(file)
	if file == nil then return nil end
  if not t2utils.file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function t2utils.read_file(path)
	local file = io.open(path, "rb") -- r read mode and b binary mode
	if not file then return nil end
	local content = file:read "*a" -- *a or *all reads the whole file
	file:close()
	return content
end


function t2utils.split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function t2utils.splitKeys(str)
	local las = str
  local t = {}
	-- ngx.log(ngx.ERR, "las: ", las)
	-- filter out id=Gkey form
	if las ~= nil then
		local p1 = las:find('=')
		if p1 ~= nil then
			las = las:sub(p1 + 1)
		end
		
		i = 1
		t = t2utils.split(las, ",")
	end
-- debug output
		-- for k,v in pairs(t) do
			-- ngx.log(ngx.ERR, "t[", k, "]=", v)
		-- end
-- debug output - end of	
	return t
end 

function t2utils.getUsernameFromHeader(aheader)
	--ngx.log(ngx.ERR, "aheader: ", aheader)

	local username = "";
	if aheader ~= nil and  aheader:find(" ") ~= nil then
		local divider = aheader:find(' ')
		if aheader:sub(0, divider-1) ~= 'Basic' then
			return ""
		end
		
		local auth = ngx.decode_base64(aheader:sub(divider+1))
		if auth == nil or auth:find(':') == nil then
			return ""
		end

		local divider = auth:find(':')
		username = auth:sub(0, divider-1)
		-- password = auth:sub(divider+1)
	end 
	return username
end

function t2utils.pullKeysForUser(auser)
	if auser == nil or auser == "" then
		return 
	end;
	
	local dbs = require("scripts.t2settings");
	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok

	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	db:set_timeout(2000)
	ok, err, errno, sqlstate = db:connect{
		host     = dbs.MysqlHost,
		port     = dbs.MysqlPort,
		database = dbs.MysqlDBName,
		user     = dbs.MysqlLogin,
		password = dbs.MysqlPassword
	}
	
	local query = "SELECT tele_keys FROM `users` WHERE login=%s"
	query = string.format(query, ngx.quote_sql_str(auser));
	res, err, errno, sqlstate = db:query(query)
	if res and res[1] then
		local sdbkeys = res[1]["tele_keys"]
		-- ngx.log(ngx.ERR, "sdbkeys:", sdbkeys)

		local gul = ngx.shared.g_uservskeyslist
		gul:set(auser, sdbkeys);
	end
end

return t2utils;
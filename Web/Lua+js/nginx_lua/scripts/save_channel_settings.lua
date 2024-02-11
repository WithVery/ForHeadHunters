-- no channel? return then
if ngx.var.arg_c == nul then
	ngx.log(ngx.ERR, "invalid channel arg: ", ngx.var.arg_c)
	return
end

ngx.req.read_body()
-- ngx.log(ngx.ERR, "=>", ngx.req.get_body_data())
	
local sdata = cjson.decode(ngx.req.get_body_data())

local na = sdata["anchors"]
local ta = sdata["triggers"]

local cn = tonumber(ngx.var.arg_c)

-- out of range? return
if cn < 1 or cn > 4 then
	ngx.log(ngx.ERR, "invalid channel: ", cn)
	return
end

--local gcs = ngx.shared.globalchannelssettings
local gs = ngx.shared.globalsettings
local gcs = gs:get("channels");
local gcst = cjson.decode(gcs)
local saveToDB = false;

function updateSettingValue(aarg, aparam)
	if aarg then
		
		if gcs == null then
			ngx.log(ngx.ERR, "gcs =>", gcs);
			return null
		end
		
		local retval = null;
		--ngx.log(ngx.ERR, "before:", gcs);
		--ngx.log(ngx.ERR, aparam, ":", aarg);
		

		local oldvalue = null;
		
		for i,line in ipairs(gcst) do
			if line["id"] == cn then
				local cs = line["settings"]
				-- ngx.log(ngx.ERR, "cs =>",cs);
				if cs ~= null then
					local cst = cjson.decode(cs);
					cst[aparam] = aarg
				end
				cst = cjson.decode(line["settings"])
				--ngx.log(ngx.ERR, "cst =>",cst);
				
				oldvalue = cst[aparam];
				--ngx.log(ngx.ERR, "OV[" , aparam, "] =>", oldvalue);
				cst[aparam] = aarg;
				--ngx.log(ngx.ERR, "NV[" , aparam, "] =>", cst[aparam]);
				if((oldvalue == null) or (oldvalue ~= aarg)) then
					saveToDB = true;
					--ngx.log(ngx.ERR, "Save it!");
				end
				retval = cjson.encode(cst)
				line["settings"] = retval
				--ngx.log(ngx.ERR, "retval = ", retval);
			end
		end 
		
		-- ngx.log(ngx.ERR, "after:", cjson.encode(gcst));
		-- ngx.log(ngx.ERR, "retval = ", retval);
		gs:set("channels", cjson.encode(gcst));
		
		return retval;
		-- local oldvalue = null;
		-- if(cs) then
			-- local cts = cjson.decode(cs)
			-- oldvalue = cts[aparam];
			-- cts[aparam] = aarg;
			-- gcs:set(channel, cjson.encode(cts));
		-- else
			-- local jj = cjson.encode({aparam = aarg});
			-- gcs:set(channel, cjson.encode({aparam = aarg}));
		-- end
		-- if((oldvalue == null) or (oldvalue ~= aarg)) then
			-- saveToDB = true;
		-- end
	end
end

local cset = null
-- parse channel settings values
if ngx.var.arg_daystartsat then
	cset = updateSettingValue(ngx.var.arg_daystartsat, "daystartsat")
end

if ngx.var.arg_blockpromo then
	cset = updateSettingValue(ngx.var.arg_blockpromo, "blockpromo")
end

if ngx.var.arg_winbefore then
	cset = updateSettingValue(ngx.var.arg_winbefore, "winbefore")
end

if ngx.var.arg_winafter then
	cset = updateSettingValue(ngx.var.arg_winafter, "winafter")
end

-- local cmd = cn .. ' channelsettings ' .. cset;

-- ngx.log(ngx.ERR, "cset:", cset);
-- ngx.exit(200)
-- ngx.log(ngx.ERR, "cmd=", cmd)

-- local globalcmd = ngx.shared.globalcmd
-- local id = "G1518"
-- local oldcmd = globalcmd:get(id)
-- if (oldcmd and not(oldcmd == '')) then
	-- -- push cmd to stack to be sent to the remote station
	-- globalcmd:set(id,(oldcmd .. '\r\n') .. cmd);
-- else
	-- globalcmd:set(id, cmd)
-- end

-- save it to DB?

-- saveToDB = true

--if saveToDB then
-- local setup 
	local dbsettings = require("scripts.t2settings");
	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok
	
	db = mysql:new()
	if db then
		-- ngx.log(ngx.ERR, "ta2=>")
		db:set_timeout(2000)
		ok, err, errno, sqlstate = db:connect{
			host     = dbsettings.MysqlHost,
			port     = dbsettings.MysqlPort,
			database = dbsettings.MysqlDBName,
			user     = dbsettings.MysqlLogin,
			password = dbsettings.MysqlPassword
		}

		if not ok then
				ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
				ngx.exit(500)
		end
		
		local vals = "";
		-- add new anchors
		for key,value in pairs(na) do 
			local args = "("..cn..","..ngx.quote_sql_str(value["n"])..","..value["as"]..","..value["bw"]..","..value["aw"]..")"
			if vals ~= "" then
				vals = vals..","
			end
			vals = vals..args
			
		--	ngx.log(ngx.ERR, key)
			--	ngx.log(ngx.ERR, cjson.encode(value))
		end
		-- ngx.log(ngx.ERR, vals)
		
		-- clean old anchors
		local sq = "DELETE FROM`anchors`WHERE`c`=%s"
		-- --local val = ngx.quote_sql_str(gcs:get(cn))
		-- local val = ngx.quote_sql_str(cset)	
		sq = string.format(sq, cn);
		--ngx.log(ngx.ERR, sq)
		res, err, errno, sqlstate = db:query(sq)
		
		
-- INSERT INTO `anchors` (`idx`, `с`, `name`, `isas`, `bw`, `aw`) VALUES (NULL, '1', 'adf', '0', '0', '0'), (NULL, '1', 'asdf', '0', '1', '1');
		if vals ~= "" then
			-- local sq = "UPDATE channels SET settings=%s WHERE id=%s"
			local sq = "INSERT INTO`anchors`(`c`,`name`,`isas`,`bw`,`aw`)VALUES %s"
			-- --local val = ngx.quote_sql_str(gcs:get(cn))
			-- local val = ngx.quote_sql_str(cset)	
			sq = string.format(sq, vals);
			-- ngx.log(ngx.ERR, sq)
			res, err, errno, sqlstate = db:query(sq)
		end
	end
--end

-- update triggers table
for key,value in pairs(ta) do 
	local sq = "UPDATE`triggers`SET`anchor`=%s,`sensitivity`=%s,`delay`=%s WHERE`channel`=%s AND`name`=%s"
	local name = ngx.quote_sql_str(value["n"])
	local a = ngx.quote_sql_str(value["a"])
	local s = ngx.quote_sql_str(value["s"])
	local d = ngx.quote_sql_str(value["d"])
	sq = string.format(sq, a, s, d, cn, name)
	res, err, errno, sqlstate = db:query(sq)
end

-- send refresh config commands
local t2s = require("scripts.t2settings");
local utils = require("scripts.t2utils");

local cmd = cjson.encode({vtbasedir = t2s.RootDataFolder.."\\"..cn.."\\"..t2s.VideoTriggersFolder});
--local var1 = "vtbasedir"
--local val1 = "aa"
--local cmd = cjson.encode({var1 = val1})
--ngx.log(ngx.ERR, cmd)
--utils.queueCmd("G1518", cn.." channelsettings "..cmd)
local user = utils.getUsernameFromHeader(ngx.req.get_headers()['Authorization'])
utils.queueBcastChannelCmd(user, cn, "channelsettings "..cmd)
utils.queueBcastChannelCmd(user, cn, "channelsettings "..cjson.encode(sdata))








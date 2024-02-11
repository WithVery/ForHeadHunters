-- no channel? return then
if ngx.var.arg_c == nul then
	ngx.log(ngx.ERR, "invalid channel arg: ", ngx.var.arg_c)
	return
end

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

--https://127.0.0.1:8081/setchannelsettings/?c=1&daystartsat=6
--https://127.0.0.1:8081/setchannelsettings/?c=1&daystartsat=8&blockpromo=0&winbefore=5&winafter=0

-- add mass sendcmd to all channels !!!

-- make it for one channel only so far

--local gcs = gs:get("channels");

-- local chs = gcs:get(cn)

local cmd = cn .. ' channelsettings ' .. cset;

-- ngx.log(ngx.ERR, "cset:", cset);

-- ngx.exit(200)


-- ngx.log(ngx.ERR, "cmd=", cmd)

local globalcmd = ngx.shared.globalcmd
local id = "G1518"
local oldcmd = globalcmd:get(id)
if (oldcmd and not(oldcmd == '')) then
	-- push cmd to stack to be sent to the remote station
	globalcmd:set(id,(oldcmd .. '\r\n') .. cmd);
else
	globalcmd:set(id, cmd)
end

-- save it to DB?
if saveToDB then
-- local setup 
	local db_username = "root"
	local db_password = ""

	local db_name = "t2u"

	-- Windows version
	local db_host = "127.0.0.1"
	local db_port = "3306"
	-- Windows version - end of
	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok
	
	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	db:set_timeout(2000)
	ok, err, errno, sqlstate = db:connect{
-- *nix version
--        path = db_socket,
-- *nix version - end of
-- Windows version
			host = db_host,
			port = db_port,
-- Windows version - end of
			database = db_name,
			user = db_username,
			password = db_password
	}

	if not ok then
			ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
			ngx.exit(500)
	end
	
	local sq = "UPDATE channels SET settings=%s WHERE id=%s"
	--local val = ngx.quote_sql_str(gcs:get(cn))
	local val = ngx.quote_sql_str(cset)	
	sq = string.format(sq, val, cn);
	res, err, errno, sqlstate = db:query(sq)
end



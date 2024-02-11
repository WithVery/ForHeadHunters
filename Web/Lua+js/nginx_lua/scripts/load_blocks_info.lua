if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") or (ngx.var.arg_date == nil) or (ngx.var.arg_date == "") then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local sid = ngx.var.arg_id
local sdate = ngx.var.arg_date
-- ngx.log(ngx.ERR, "sid=>", sid)
-- ngx.log(ngx.ERR, "sdate=>", sdate)

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");
local t2s8 = require("scripts.t2utf8");

local keys = t2u.split(sid, ",")
local stinfo = {}

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
	
	if vals ~= "" then
		-- local query = "SET CHARSET cp1251"
		local query = "SET CHARSET utf8"
		res, err, errno, sqlstate = db:query(query)

		if not res then
			ngx.log(ngx.ERR, "Failed to set up a codepage: ", err, ": ", errno, ": ", sqlstate, ".")
			return
		end
	end

	for i = 1, #keys do	
		local stid = keys[i]:sub(2)
		-- local tt = stinfo[keys[i]]
		stinfo[keys[i]] = {}
		-- tt = {}
		for j = 1, 4 do	
			-- ngx.log(ngx.ERR, "stid>", stid)
			-- pull info from DB
			-- local sq = 'SELECT`city`FROM`stations`WHERE`keyid`=%s LIMIT 1'
			local sq = 'SELECT s_start,s_name,s_dur FROM `scheds` WHERE s_c=%d AND s_keyid=%s AND s_day="%s" AND s_type=0'
			sq = string.format(sq, j, stid, sdate);
			--ngx.log(ngx.ERR, "sq>", sq)
			res, err, errno, sqlstate = db:query(sq)
			if res then -- and res[1] then
				-- local stname = res[1]["city"]
				--stinfo[keys[i]] = cjson.encode({name = stname})
				--ngx.log(ngx.ERR, "res>", cjson.encode(res))
				--tt[j] = cjson.encode({bs = res})
				--tt[tostring(j)] = cjson.encode(res)
				stinfo[keys[i]][tostring(j)] = cjson.encode(res)
			end
			-- ngx.log(ngx.ERR, "t>", cjson.encode(stinfo))			
		end
	end
end

--ngx.log(ngx.ERR, cjson.encode(stinfo))
ngx.say(cjson.encode(stinfo))

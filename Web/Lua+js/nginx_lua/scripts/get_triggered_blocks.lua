ngx.header.content_type = 'application/json';

if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") or (ngx.var.arg_after == nil) or (ngx.var.arg_after == "") then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");

local ids = ngx.var.arg_id
local after = ngx.var.arg_after

-- ngx.log(ngx.ERR, "id =>", ids)
-- ngx.log(ngx.ERR, "after=>", after)

local keys = t2u.split(ids, ",")
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
	
	-- if vals ~= "" then
		-- -- local query = "SET CHARSET cp1251"
		-- local query = "SET CHARSET utf8"
		-- res, err, errno, sqlstate = db:query(query)

		-- if not res then
			-- ngx.log(ngx.ERR, "Failed to set up a codepage: ", err, ": ", errno, ": ", sqlstate, ".")
			-- return
		-- end
	-- end

	for j = 1, 4 do	
		stinfo[tostring(j)] = {}
		for i = 1, #keys do	
			local stid = keys[i]
			-- ngx.log(ngx.ERR, "stid>", stid)
			-- pull info from DB
			

			--local sq = 'SELECT s_start,s_name,s_dur FROM `scheds` WHERE s_c=%d AND s_keyid=%d AND s_day="%s" AND s_type=0'
			local sq = 'SELECT log_time as lt,schedtime AS st,action_code AS ac FROM`log`WHERE`action_code` IN (3,6,8,11,12,13)AND(log_time>"%s") AND channel=%d AND station="%s" AND action_type=0'
			sq = string.format(sq, after, j, stid);
			-- ngx.log(ngx.ERR, "sq>", sq)
			res, err, errno, sqlstate = db:query(sq)
			if res then -- and res[1] then
				--ngx.log(ngx.ERR, "res>", cjson.encode(res));
				stinfo[tostring(j)][stid] = cjson.encode(res)
			end
			-- ngx.log(ngx.ERR, "t>", cjson.encode(stinfo))			
		end
	end
end

--ngx.log(ngx.ERR, cjson.encode(stinfo))
ngx.say(cjson.encode(stinfo))

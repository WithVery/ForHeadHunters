if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local sid = ngx.var.arg_id

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");
local t2s8 = require("scripts.t2utf8");

lines = t2u.split(sid, ",")
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

	for i = 1, #lines do	
		local stid = lines[i]:sub(2)
		-- ngx.log(ngx.ERR, "stid>", stid)
		-- pull info from DB
		local sq = 'SELECT`city`FROM`stations`WHERE`keyid`=%s LIMIT 1'
		sq = string.format(sq, stid);
		res, err, errno, sqlstate = db:query(sq)
		if res and res[1] then
			local stname = res[1]["city"]
			stinfo[lines[i]] = cjson.encode({name = stname})
		end
	end
end

ngx.say(cjson.encode(stinfo))

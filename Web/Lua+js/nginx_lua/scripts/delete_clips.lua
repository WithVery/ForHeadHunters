if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") then
	ngx.log(ngx.ERR, arg_id)
	ngx.say("ERROR")
	ngx.exit(200)
end

local sid = ngx.var.arg_id

ngx.req.read_body()
local rbody = ngx.req.get_body_data()
ngx.log(ngx.ERR, rbody)

local t2s = require("scripts.t2settings")
local t2u = require("scripts.t2utils")
local t2s8 = require("scripts.t2utf8")

local lines = {}

lines = t2u.strToLines(rbody)

ngx.log(ngx.ERR, #lines)

rbody = ""

local rest = {}

local dbsettings = require("scripts.t2settings");
local mysql = require "resty.mysql"

local db, err, errn, sqlstate, res, ok

local errnodb = -1

db = mysql:new()
if db then
	-- ngx.log(ngx.ERR, "ta2=>")
	db:set_timeout(2000)
	ok, err, errnodb, sqlstate = db:connect{
		host     = dbsettings.MysqlHost,
		port     = dbsettings.MysqlPort,
		database = dbsettings.MysqlDBName,
		user     = dbsettings.MysqlLogin,
		password = dbsettings.MysqlPassword
	}

	if not ok then
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errnodb, " ", sqlstate)
		ngx.exit(500)
		errnodb = -1
	else
		local query = "SET CHARSET cp1251"
		-- local query = "SET CHARSET utf8"
		res, err, errnodb, sqlstate = db:query(query)

		if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errnodb, ": ", sqlstate, ".")
			ngx.exit(500)
		end
	end
end

for i = 1, #lines do

	--local sftmp = rbody --t2s8.fromutf8(rbody)
	local sftmp = t2u.trim(lines[i]) --t2s8.fromutf8(rbody)
	if(sftmp ~= "") then
		local sfname = t2s8.fromutf8(sftmp)

		local lpath = t2s.RootDataFolder.."\\Stations\\"..sid.."\\"..t2s.VideoClipsFolder.."\\"
		local lclip = lpath..sfname
		local re, err, errno = os.remove(lclip)

		sfname = sfname..".md5"
		local lclipmd5 = lpath..sfname

		local remd5, errmd5, errnomd5 = os.remove(lclipmd5)
		
		local sq = "DELETE FROM`clips`WHERE`path`=%s"
		sq = string.format(sq, ngx.quote_sql_str(lclip));

		res, err, errnodb, sqlstate = db:query(sq)
		if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errnodb, ": ", sqlstate, ".")
		end
		
		rest[sftmp] = cjson.encode({f = errno, md5 = errnomd5, db = errnodb})
	end 
end

ngx.say(cjson.encode(rest))
ngx.exit(200)

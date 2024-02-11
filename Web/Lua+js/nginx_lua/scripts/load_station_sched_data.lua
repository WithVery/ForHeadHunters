if ngx.var.arg_id == nil then
	ngx.log(ngx.ERR, "No key submitted!")
	ngx.say("UNDEF")
	ngx.exit(200)
end

-- station key
local sid = ngx.var.arg_id
local nid = string.sub(sid, 2)
-- ngx.log(ngx.ERR, "> ", sid)
-- ngx.log(ngx.ERR, "> ", nid)

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");
local t2s8 = require("scripts.t2utf8");

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
		return
end

-- local aid
local cname
local acns

-- get station name by ID
query = "SELECT city FROM`stations`WHERE keyid=%s LIMIT 1"
query = string.format(query, nid);
res, err, errno, sqlstate = db:query(query)
if res then
	cname = res[1]["city"]
else
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end
-- ngx.log(ngx.ERR, "cname:", cname)

-- get channel names
query = "SELECT id,title FROM`channels`ORDER BY id"
query = string.format(query, nid);
res, err, errno, sqlstate = db:query(query)
if res then
	--acns = t2s8.toutf8(cjson.encode(res));
	acns = cjson.encode(res)
else
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end

local scheddata = {}

local ct = os.time()

for cn = 1, 4, 1 do
	scheddata[cn] = {}
	for i = 0, 6, 1 do
		-- txt section
		local curt = os.time({year=os.date("%Y", ct), month = os.date("%m", ct), day = os.date("%d", ct) + i})
		local cfn = "txt_"..cn.."_"..os.date("%Y_%m_%d", curt)..".txt"
		local lpath = t2s.RootDataFolder.."\\Stations\\"..sid.."\\txt\\"..cfn
		local st = os.date("%d/%m/%Y", curt)
		
		if t2u.file_exists(lpath) then
			local sjd = scheddata[cn][st];
			local cdt = {}
			if sjd ~= nil then
				cdt = cjson.decode(sjd)
			end
			cdt["txt"] = 1
			sjd = cjson.encode(cdt)
			scheddata[cn][st] = sjd
		end
		
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
			local sjd = scheddata[cn][st];
			local cdt = {}
			if sjd ~= nil then
				cdt = cjson.decode(sjd)
			end
			cdt["tvb"] = resj
			sjd = cjson.encode(cdt)
			scheddata[cn][st] = sjd
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
			local sjd = scheddata[cn][st];
			local cdt = {}
			if sjd ~= nil then
				cdt = cjson.decode(sjd)
			end
			cdt["ads"] = resj
			sjd = cjson.encode(cdt)
			scheddata[cn][st] = sjd
		end
		-- ads section - end of
		
		-- imported schedule info for date/channel
		local impres = t2u.loadSchedData(sid, cn, os.date("%Y", curt), os.date("%m", curt), os.date("%d", curt))
		if (impres ~= "") and (impres ~= "{}") then 
			local sjd = scheddata[cn][st];
			local cdt = {}
			if sjd ~= nil then
				cdt = cjson.decode(sjd)
			end
			cdt["ir"] = impres
			sjd = cjson.encode(cdt)
			scheddata[cn][st] = sjd
		end
		
		-- cdt["impres"] = 
		-- local sdq = t2u.loadSchedData(sid, cn, os.date("%Y", curt), os.date("%m", curt), os.date("%d", curt))
		-- ngx.log(ngx.ERR, sdq);
		-- imported schedule info for date/channel - end of
	end
end
-- ngx.log(ngx.ERR, ">", cjson.encode(scheddata))

ngx.header.content_type = 'application/json';

--local ut = {city = t2s8.toutf8(cname), chdata = acns, schdata = cjson.encode(scheddata)};
local ut = {city = cname, chdata = acns, schdata = cjson.encode(scheddata)};

ngx.say(cjson.encode(ut))
ngx.exit(200)

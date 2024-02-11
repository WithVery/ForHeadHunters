-- local cjson = require "cjson"

-- local setup 
local db_username = "root"
local db_password = ""

local db_name = "t2u"

-- IP version
local db_host = "127.0.0.1"
local db_port = "3306"
-- IP version - end of

-- pull channel names from database
local mysql = require "resty.mysql"
local db, err, errno, sqlstate, res, ok

db = mysql:new()
if not db then
	ngx.log(ngx.ERR, "Failed to create mysql object")
	ngx.exit(500)
end

db:set_timeout(2000)

ok, err, errno, sqlstate = db:connect{
-- socket version
--        path = db_socket,
-- socket version - end of
-- IP version
		host = db_host,
		port = db_port,
-- IP version - end of
		database = db_name,
		user = db_username,
		password = db_password
}

if not ok then
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end

--local guk = ngx.shared.g_userkeys
local gs = ngx.shared.globalsettings
--local gs = ngx.shared.globalstatus
--ngx.log(ngx.ERR, "gs => ", cjson.encode(gs))

	
-- ngx.log(ngx.ERR, "Some keys are not in cache! => querying the DB.")

local query = "SET CHARSET utf8"
res, err, errno, sqlstate = db:query(query)

if not res then
		ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
		return
end

local query = "SELECT id,title,settings FROM `channels`"
res, err, errno, sqlstate = db:query(query)

if not res then
		ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
		return
end

gs:set("channels", cjson.encode(res));

-- local gcs = ngx.shared.globalchannelssettings
-- local query = "SELECT id,settings FROM `channels`"
-- res, err, errno, sqlstate = db:query(query)

-- if not res then
		-- ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
		-- return
-- end

-- gcs:set(channel, cjson.encode({aparam = aarg}));



--local jr = cjson.encode(res);
-- ngx.log(ngx.ERR,"result: ", cjson.encode(res))
--local jt = cjson.decode(jr);

--for i,line in ipairs(res) do
	--ngx.log(ngx.ERR, line["id"], "=>", line["title"])
	--gcn["id"] = line["id"];
	--ngx.log(ngx.ERR, "line =>", i)
	--gcn:set(line["id"], line["title"]);
	--ngx.log(ngx.ERR, "result1: ", cjson.encode(gcn))
--end

--ngx.log(ngx.ERR,"result: ", cjson.encode(ngx.shared.g_channelnames))
--ngx.log(ngx.ERR,"result: ", cjson.encode(gcn))
--ngx.log(ngx.ERR, "globalstatus: ", cjson.encode(ngx.shared.globalstatus))

--for i,line in ipairs(ngx.shared.g_channelnames) do
--for i,line in ipairs(gcn) do
	--ngx.log(ngx.ERR, ngx.shared.g_channelnames[i])
	
	--ngx.log(ngx.ERR, "line =>", cjson.encode(line))
	--ngx.log(ngx.ERR, "line =>", i)
	--ngx.log(ngx.ERR, "get =>", line[1])
	--print(line)
	--ngx.log(ngx.ERR, gcn:get(line["id"}))
	--gcn:set(line["id"], line["title"]);
	--ngx.log(ngx.ERR, "result1: ", cjson.encode(gcn))
--end





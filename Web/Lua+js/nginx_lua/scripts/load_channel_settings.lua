if ngx.var.arg_c == nil then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local t2s = require("scripts.t2settings");
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

local query = "SELECT idx,name as n,bw,aw,isas FROM `anchors` WHERE c=%d ORDER BY n"
query = string.format(query, tonumber(ngx.var.arg_c));
res, err, errno, sqlstate = db:query(query)
if res then
	ngx.header.content_type = 'application/json';
	--ngx.say(cjson.encode(res))
	-- ngx.log(ngx.ERR, ":->", cjson.encode(res))
else
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end

local aj = cjson.encode(res);
-- --local handle = io.popen(command)
-- local handle = io.popen("dir c:\\Users\\admin\\Desktop\\*.pdf", "r")
-- local result = handle:read("*a")
-- handle:close()

-- ngx.log(ngx.ERR, "result: ")
-- ngx.log(ngx.ERR, result)

local ii = 1;

-- pull data from DB
	-- pull channel names from database
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

	if not ok then
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
		ngx.exit(500)
	end

	--local query = "SELECT schedtime AS t, systemtime AS st FROM anchorstriggered WHERE station=%s AND channel=%s AND sday=%s GROUP BY t"
	local query = "SELECT name AS n, anchor AS a, sensitivity AS s, delay AS d FROM triggers WHERE channel=%s"
	query = string.format(query, ngx.var.arg_c);
	-- ngx.log(ngx.ERR, "query! = ", query)

	res, err, errno, sqlstate = db:query(query)

	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return
	end
	
local triggers = cjson.encode(res)

-- ngx.log(ngx.ERR, "> ", triggers);

local lp = t2s.RootDataFolder.."\\"..ngx.var.arg_c.."\\"..t2s.VideoTriggersFolder.."\\*.*"


--for dir in io.popen([[dir "c:\Users\admin\Desktop\*.pdf" /b]]):lines() do
local lcmd = "dir \""..lp.."\" /b"
--for dir in io.popen([[dir "c:\Users\admin\Desktop\*.pdf" /b]]):lines() do

-- local cf = io.popen(lcmd);
-- ngx.log(ngx.ERR, "cf:=>", type(cf))
-- ngx.log(ngx.ERR, ":=>", cjson.decode(cf))


local cft = {}
local cft1 = {}
local cftn = {}
for dir in io.popen(lcmd):lines() do
	cft[ii] = dir;
	cft1[dir] = ii;
	--cftn[ii] = '{"n":"'..dir..'"}'
	
	for i = 1, #res do	
		local sn = res[i]["n"]
		if sn == dir then
			cftn[ii] = res[i]
		end
	end
	-- ngx.log(ngx.ERR, ii, ": ", dir)
	-- print(dir)
	ii = ii + 1;
end

local cfj = cjson.encode(cft);
local cfj1 = cjson.encode(cft1);
local cfjn = cjson.encode(cftn);
-- ngx.log(ngx.ERR, ": ", cfj)
-- ngx.log(ngx.ERR, ": ", cfjn)

local ut = {};
ut["anchors"]  = aj;
ut["triggers"] = cfjn;

-- ngx.log(ngx.ERR, ":=>", cjson.encode(ut))
ngx.say(cjson.encode(ut))


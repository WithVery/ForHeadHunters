ngx.header.content_type = 'application/json';
--ngx.log(ngx.ERR, "!")

--if ngx.var.arg_c and ngx.var.arg_d and ngx.var.arg_id then
if ngx.var.arg_c and ngx.var.arg_d then
	--ngx.log(ngx.ERR, "arg_c =>1")
	--ngx.log(ngx.ERR, "=>", ngx.var.arg_c, ":",ngx.var.arg_d)
	--local ta = ngx.shared.globaltriggered:get(ngx.var.arg_id..ngx.var.arg_c..ngx.var.arg_t)
	
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
	local query = "SELECT schedtime AS t, systemtime AS st FROM log WHERE channel=%s AND sday=%s AND title <> '' GROUP BY t"
	query = string.format(query, ngx.var.arg_c, ngx.quote_sql_str(ngx.var.arg_d));
	--ngx.log(ngx.ERR, "query! = ", query)

	res, err, errno, sqlstate = db:query(query)

	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return
	end

--ngx.log(ngx.ERR, "res: ", cjson.encode(res))
	ngx.say(cjson.encode(res))
else
		ngx.say("UNDEF")
end
-- ngx.update_time()
-- ngx.shared.globalstatus:set('statuslastupdate'..ngx.var.arg_id, ngx.now())

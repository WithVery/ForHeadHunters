ngx.header.content_type = 'application/json';
-- ngx.log(ngx.ERR, "c = ", ngx.var.arg_c)
-- ngx.log(ngx.ERR, "d = ", ngx.var.arg_date)

if ngx.var.arg_c and ngx.var.arg_date then
	--ngx.log(ngx.ERR, "channel =>", ngx.var.arg_c)
	--ngx.log(ngx.ERR, "date =>", ngx.var.arg_date)
	-- ngx.shared.globalstatus:set('status'..ngx.var.arg_id, ngx.var.arg_p)
	-- local as = ngx.shared.globalanchors:get(ngx.var.arg_c)
	
-- SELECT * FROM `scheds` WHERE s_c=1 and s_day='2018-08-24' ORDER BY s_start
	-- local setup 
	local db_username = "root"
	local db_password = ""
	local db_name = "t2u"
	-- -- IP version
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

	local query = "SET CHARSET utf8"
	res, err, errno, sqlstate = db:query(query)

	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return
	end 
	
	local query = "SELECT * FROM`scheds`WHERE`s_c`=%s and s_day=%s ORDER BY s_start,s_type DESC";
	query = string.format(query, ngx.var.arg_c, ngx.quote_sql_str(ngx.var.arg_date));
	-- ngx.log(ngx.ERR, "query! = ", query)

	res, err, errno, sqlstate = db:query(query)

	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return
	end

	--gs:set("items:", cjson.encode(res));
-- ! --
--res, err, errno, sqlstate = db:query(query)
	--ngx.log(ngx.ERR, "items:", cjson.encode(res));

	ngx.say(cjson.encode(res))
	-- ngx.log(ngx.ERR, "=>", as)
	--ngx.say(as)
else
		ngx.say("UNDEF")
end
-- ngx.update_time()
-- ngx.shared.globalstatus:set('statuslastupdate'..ngx.var.arg_id, ngx.now())

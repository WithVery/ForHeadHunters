if ngx.var.arg_c == nil then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local t2s = require("scripts.t2settings");

ngx.req.read_body()
fn = ngx.req.get_body_data()
-- ngx.log(ngx.ERR, "fn=>", fn)

file_name = t2s.RootDataFolder.."\\"..ngx.var.arg_c.."\\"..t2s.VideoTriggersFolder.."\\"..string.gsub(fn, "\"", "")
--ngx.log(ngx.ERR, file_name)

local res, errmsg = os.remove(file_name)
if res ~= true then
	ngx.log(ngx.ERR, errmsg)
	ngx.say("ERROR: ", fn, " ", errmsg)
else
	-- ngx.log(ngx.ERR, "OK")
	ngx.say("OK")
end




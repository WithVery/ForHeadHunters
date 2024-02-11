local utils = require("scripts.t2utils");
local t2s = require("scripts.t2settings");

local uname = utils.getUsernameFromHeader(ngx.req.get_headers()['Authorization'])

-- ngx.log(ngx.ERR, "uname:", uname)
-- ngx.log(ngx.ERR, "client ip:", ngx.var.remote_addr)
-- ngx.log(ngx.ERR, "channel:", ngx.var.arg_c)
-- ngx.log(ngx.ERR, "IDs:", ngx.var.arg_id)

-- reset active block caches
-- input parameters: Date, Channel, StationID

if (uname == "") or (ngx.var.arg_d == nil) or (ngx.var.arg_c == nil) or (ngx.var.arg_id == nil) then
	-- ngx.log(ngx.ERR, "failed");
	-- ngx.log(ngx.ERR, uname);
	-- ngx.log(ngx.ERR, ngx.var.arg_c);
	-- ngx.log(ngx.ERR, ngx.var.arg_id);
	return
end

--ngx.req.read_body()
--local cmd = ngx.req.get_body_data()

utils.logWebAction(uname, ngx.var.remote_addr, ngx.var.arg_c, ngx.var.arg_id, "ActiveBlockCache reset: " .. ngx.var.arg_d)

utils.resetActiveBlocksCache(ngx.var.arg_d, ngx.var.arg_c, ngx.var.arg_id)

ngx.say("OK")
ngx.exit(200) 
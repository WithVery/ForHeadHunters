ngx.header.content_type = 'application/json';
local globalstatus = ngx.shared.globalstatus
--ngx.log(ngx.ERR, cjson.encode(ngx.var))

--ngx.log(ngx.ERR, "id =>", ngx.var.arg_id)
local res=globalstatus:get('status'..ngx.var.arg_id)
--ngx.log(ngx.ERR, "res =>", res)
local sid = ngx.var.arg_id
--ngx.log(ngx.ERR, "res =>", res)

local lastupd=globalstatus:get('statuslastupdate'..ngx.var.arg_id)
-- local lcht = cjson.encode(ngx.shared.g_channelnames)
local settings = ngx.shared.globalsettings
local channels = settings:get('channels')
--ngx.log(ngx.ERR, "lcht =>", lcht)

local t2u = require("scripts.t2utils");

if res then
	if lastupd then
		if (ngx.now()-lastupd<10) then
			--ngx.say(cjson.encode({res, chs = channels}))
			local scheddata = t2u.loadSchedDataInfo(sid)
			--ngx.log(ngx.ERR, scheddata)
			
			local restbl = cjson.decode(res)
			restbl["sd"] = scheddata
			res = cjson.encode(restbl)
			
			ngx.say(res)
			-- ngx.log(ngx.ERR, "res1 =>", res)
			--ngx.say(cjson.encode({chs = channels}))
			
			--ngx.log(ngx.ERR, "lcht1 =>", cjson.encode({cht = lcht}))
			--ngx.say(cjson.encode({id = ngx.var.arg_id, p = "timeout", timeout=(ngx.now()-lastupd), cht = lcht}))
			-- ngx.say(res)
		else
			-- ngx.say(cjson.encode({id = ngx.var.arg_id, p = "timeout", timeout=(ngx.now()-lastupd)}))
			local scheddata = t2u.loadSchedDataInfo(sid)
			
			ngx.say(cjson.encode({id = ngx.var.arg_id, p = "timeout", timeout=(ngx.now()-lastupd), cht = lcht, sd = scheddata}))
			--ngx.say(cjson.encode({id = ngx.var.arg_id, p = "timeout", timeout=(ngx.now()-lastupd), cht = lcht}))
		end
	end
else
	ngx.say("UNDEF")
end

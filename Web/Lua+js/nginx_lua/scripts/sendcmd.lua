ngx.req.read_body()
local cmd = ngx.req.get_body_data()
local id = ngx.var.arg_id
ngx.log(ngx.ERR, "id>", id);
ngx.log(ngx.ERR, "cmd>", cmd);

local utils = require("scripts.t2utils");
utils.queueCmd(id, cmd)

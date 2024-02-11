local t2settings = {};

function t2settings.logIt(something)
	ngx.log(ngx.ERR, something)
end

t2settings.MysqlHost     = "127.0.0.1"
t2settings.MysqlPort     = "3306"
t2settings.MysqlLogin    = "root"
t2settings.MysqlPassword = ""
t2settings.MysqlDBName   = "t2u"

t2settings.RootDataFolder      = "e:\\KZ\\ServerData"
--t2settings.RootDataFolder      = "D:\\TK" 
t2settings.VideoTriggersFolder = "triggers"
t2settings.VideoClipsFolder = "clips"


-- action log_type/log_results codes:
t2settings.LT_INFO = 0
t2settings.LT_WARN = 1
t2settings.LT_ERR  = 2

-- action codes:
t2settings.TELE_SCHED_IMPORT_COMPLETED = 14
t2settings.TVB_PROCESSING = 100
t2settings.ADS_PROCESSING = 101

return t2settings;
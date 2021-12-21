local m, s, o

m = Map("nps")
m.title = translate("Nps Server")
m.description = translate("推荐做为旁路模式搭建NPS服务器。启动（或重启）时间根据路由器性能可能在30秒~2分钟。<br />默认管理端口：7777 账号：admin 密码：admin")

m:section(SimpleSection).template = "nps/nps_status"

s = m:section(TypedSection,"nps")
s.addremove = false
s.anonymous = true

s:tab("basic",translate("Basic Setting"))
enable = s:taboption("basic",Flag,"enabled",translate("Enabled"))
enable.rmempty = false

port = s:taboption("basic",Value,"port", translate("Management Port"))
port.datatype = "port"
port.placeholder = "7777"
port.default = "7777"
port.rmempty = false

return m

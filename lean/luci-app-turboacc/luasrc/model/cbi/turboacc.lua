local kernel_version = luci.sys.exec("echo -n $(uname -r)")

m = Map("turboacc")
m.title	= translate("Turbo ACC Acceleration Settings")
m.description = translate("Opensource Flow Offloading driver (Fast Path or Hardware NAT)")

m:append(Template("turboacc/turboacc_status"))

s = m:section(TypedSection, "turboacc", "")
s.addremove = false
s.anonymous = true

if nixio.fs.access("/lib/modules/" .. kernel_version .. "/xt_FLOWOFFLOAD.ko") then
sw_flow = s:option(Flag, "sw_flow", translate("Software flow offloading"))
sw_flow.default = 0
sw_flow.description = translate("Software based offloading for routing/NAT")
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/mtkhnat.ko") then
sw_flow:depends("hw_flow", 0)
else
sw_flow:depends("sfe_flow", 0)
end
end

if luci.sys.call("cat /etc/openwrt_release | grep -Eq 'filogic|mt762' ") == 0 then
hw_flow = s:option(Flag, "hw_flow", translate("Hardware flow offloading"))
hw_flow.default = 0
hw_flow.description = translate("Requires hardware NAT support. Implemented at least for mt762x")
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/mtkhnat.ko") then
hw_flow:depends("sw_flow", 0)
else
hw_flow:depends("sw_flow", 1)
end
end

if nixio.fs.access("/lib/modules/" .. kernel_version .. "/shortcut-fe-cm.ko")
or nixio.fs.access("/lib/modules/" .. kernel_version .. "/fast-classifier.ko")
then
sfe_flow = s:option(Flag, "sfe_flow", translate("Shortcut-FE flow offloading"))
sfe_flow.default = 0
sfe_flow.description = translate("Shortcut-FE based offloading for routing/NAT")
sfe_flow:depends("sw_flow", 0)
end

if nixio.fs.access("/lib/modules/" .. kernel_version .. "/xt_FULLCONENAT.ko") then
fullcone_nat = s:option(Flag, "fullcone_nat", translate("FullCone NAT"))
fullcone_nat.default = 0
fullcone_nat.description = translate("Using FullCone NAT can improve gaming performance effectively")
end

bbr_cca = s:option(ListValue, "bbr_cca", translate("BBR CCA"))
bbr_cca:value("0", translate("CUBIC"))
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/tcp_bbr.ko") then
bbr_cca:value("bbr", translate("Enable BBR"))
end
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/tcp_bbrplus.ko") then
bbr_cca:value("bbrplus", translate("Enable BBRPLUS"))
end
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/tcp_nanqinlang.ko") then
bbr_cca:value("nanqinlang", translate("Enable NANQINLANG"))
end
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/tcp_tsunami.ko") then
bbr_cca:value("tsunami", translate("Enable TSUNAMI"))
end
if nixio.fs.access("/lib/modules/" .. kernel_version .. "/tcp_tsunamio.ko") then
bbr_cca:value("tsunamio", translate("Enable TSUNAMIO"))
end
bbr_cca.default = 0
bbr_cca.description = translate("Using BBR CCA can improve TCP network performance effectively")


free_memory = s:option(Flag, "free_memory", translate("Automatic Free Memory"))
free_memory.default = 0
free_memory.rmempty = false

dns_acc = s:option(Flag, "dns_acc", translate("DNS Acceleration"))
dns_acc.default = 0
dns_acc.rmempty = false
dns_acc.description = translate("Using optimized DNS records for GoogleHosts (Don't use under Clash Fake-IP mode)")

if nixio.fs.access("/usr/sbin/pdnsd") or nixio.fs.access("/usr/bin/dnsforwarder") or nixio.fs.access("/usr/bin/dnsproxy") or nixio.fs.access("/usr/bin/AdGuardHome") then
dns_caching = s:option(Flag, "dns_caching", translate("DNS Caching"))
dns_caching.default = 0
dns_caching.rmempty = false
dns_caching.description = translate("Enable DNS Caching and anti ISP DNS pollution")
end

dns_caching_mode = s:option(ListValue, "dns_caching_mode", translate("Resolve DNS Mode"), translate("DNS Program, Using AdGuardHome login username/password: AdGuardHome/AdGuardHome"))
if nixio.fs.access("/usr/sbin/pdnsd") then
dns_caching_mode:value("1", translate("Using PDNSD to query and cache"))
end
if nixio.fs.access("/usr/bin/dnsforwarder") then
dns_caching_mode:value("2", translate("Using DNSForwarder to query and cache"))
end
if nixio.fs.access("/usr/bin/dnsproxy") then
dns_caching_mode:value("3", translate("Using DNSProxy to query and cache"))
end
if nixio.fs.access("/usr/bin/AdGuardHome") then
dns_caching_mode:value("4", translate("Using AdGuardHome to query and cache"))
end
dns_caching_mode.default = 1
dns_caching_mode:depends("dns_caching", 1)

dns_caching_dns= s:option(Value, "dns_caching_dns", translate("Upsteam DNS Server"))
dns_caching_dns.default = "114.114.114.114,114.114.115.115,223.5.5.5,223.6.6.6,180.76.76.76,119.29.29.29,119.28.28.28,1.2.4.8,210.2.4.8"
dns_caching_dns.description = translate("Muitiple DNS server can saperate with ','")
dns_caching_dns:depends("dns_caching_mode", 1)
dns_caching_dns:depends("dns_caching_mode", 2)
dns_caching_dns:depends("dns_caching_mode", 3)

return m

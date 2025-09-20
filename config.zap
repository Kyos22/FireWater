opt server_output = "src/Shared/Network/Server.luau"
opt client_output = "src/Shared/Network/Client.luau"
opt casing = "PascalCase"
opt write_checks = true
opt yield_type = "future"
opt async_lib = "require(game:GetService('ReplicatedStorage').Packages.Future)"

----PlayerProfile
event Player_Update_Profile = {
    from: Server,
	type: Reliable,
	call: ManyAsync,
	data: (unknown)
}
funct Get_Player_Data = {
    call: Async,
    args: (),
    rets: (unknown)
}


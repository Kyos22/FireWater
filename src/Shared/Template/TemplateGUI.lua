local module = {}
module.constructors = {}
module.methods = {}
module.metatable = { __index = module.methods }

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
local Shared = ReplicatedStorage.Shared
local SignalModule = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Signal"))
local ProfileTemplate = require(ReplicatedStorage.Controllers.Systems.PlayerProfile.ProfileTemplate)
-- local ClassInterface = require(ReplicatedStorage.Controllers.Interface.ClassInterface)
---->> Network
local Network = Shared.Network
local Client = require(Network.Client)
---->> Libraries
local Libraries = Shared.Libraries
local CONSTANTS = require(Shared.CONSTANT)
---->> Interfaces
local PlayerProfileInterface = require(ReplicatedStorage.Controllers.Interface.PlayerProfileInterface)
---->> Helper

--// Constants & Enums
local _TWEEN_EXP_ENABLE = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local _TWEEN_EXP_DISABLE = TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
--// Types & Enums
type Signal = typeof(SignalModule.new())


export type PrivateField = {
    enabled: BoolValue,

	
	tasks: { [string]: thread },
	connections: { [string]: RBXScriptConnection },

	Player: ProfileTemplate.Profile?,

}
--//Private Functions

--// Constructor
local function prototype(self: Type, ui: ScreenGui)
	---->> Public Properties
	self.UI         = ui :: ScreenGui
	
    
	---->> Private Properties
	self._private = {
		tasks = {},
		connections = {},
		Player = nil,
		
	} :: PrivateField

	return self
end

function module.methods.Initialize(self: Type)
	local _p = self._private

    _p.enabled = Instance.new("BoolValue")
    _p.enabled.Name = "Enabled"
    _p.enabled.Value = false
    _p.enabled.Parent = self.UI

	

    _p.enabled.Changed:Connect(function(newValue)
        self.UI.Enabled = newValue
    end)

    --hanlde click close button
    _p.connections["Close"] = 
        self.CloseBtn.Activated:Connect(function()
            _p.enabled.Value = false
        end)

	_p.Player = self:GetPlayer()
	

	
end

function module.methods.GetPlayer(self: Type) : ProfileTemplate.Profile
	return PlayerProfileInterface.RequestProfileDataAsync()
end



function module.methods.Open(self: Type, isAnimated: boolean?)
	local _p = self._private
	self._private.enabled.Value = true
	self._private.isActive = true
end

function module.methods.Close(self: Type, isAnimated: boolean?)
	local _p = self._private
	self._private.enabled.Value = false
	self._private.isActive = false

end

--// Private Functions
--// Destructor
module.constructors.metatable = module.metatable
module.constructors.methods = module.methods
module.constructors.private = {
}


function module.constructors.new(ui: ScreenGui)
	local self = setmetatable(prototype({}, ui), module.metatable)
	
	return self :: Type
end

function module.methods.Destroy(self: Type)
	local _p = self._private
	for _,task_ in pairs(_p.tasks) do
		if coroutine.status(task_) == "suspended" then
			task.cancel(task_)
		else
			task.defer(function()
				task.cancel(task_)
			end)
		end
	end
	for _, connection in pairs(_p.connections) do
		connection:Disconnect()
	end

    local temp = self :: {}
	for k in pairs(temp) do
        temp[k] = nil
	end
end


export type Type = typeof(prototype(...)) & typeof(module.methods)

return module.constructors
--// RunContext = Server

local testers = script.Parent:GetChildren() :: { ModuleScript }

for _, tester: ModuleScript in testers do
	if tester:IsA("Script") then continue end
	if tester.Name:find("^%-%-") then continue end
	require(tester)
end
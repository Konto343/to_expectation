for _, module in script.Parent:GetDescendants() do
    if not module:IsA('ModuleScript') then
        continue
    end

    require(module)
end

print('Modules init.')
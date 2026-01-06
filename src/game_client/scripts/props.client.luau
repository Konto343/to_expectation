game.Loaded:Wait()

for _,obj in workspace:GetDescendants() do
    if obj:IsA('Model') then
        local module = game.ReplicatedStorage.shared.props:FindFirstChild(obj.Name)

        if not module then
            continue
        end

        require(module).apply(obj)
    end
end

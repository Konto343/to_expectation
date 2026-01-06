function setup(obj)
    if obj:IsA("Model") then
        local root = obj:FindFirstChild('root', true)
        for _, part in obj:GetDescendants() do
            if part ~= root then
                local weld = Instance.new('WeldConstraint')
                weld.Part0 = part
                weld.Part1 = root
                part.Anchored = false
                weld.Parent = part
            end
        end
        root.Anchored = false
    end
end

task.wait(2)

for _, obj in workspace:GetDescendants() do
    if obj:HasTag('weldroot') then
        setup(obj)
    end
end
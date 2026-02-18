-- ============================================
-- OR's KEY SYSTEM - VERSÃO DELTA EXECUTOR
-- ============================================

local SiteURL = "https://key-system-by-or-s.vercel.app"
local KeyValidada = false

-- FUNÇÃO ESPECIAL PARA DELTA (usa syn.request se existir)
local function FazerRequisicao(url)
    -- Tenta syn.request (funciona em alguns executors)
    local sucesso, resultado = pcall(function()
        local request = syn and syn.request or http_request or request
        if request then
            local resposta = request({
                Url = url,
                Method = "GET",
                Headers = {["User-Agent"] = "Delta-Executor"}
            })
            return resposta.Body
        else
            -- Se não tiver request, tenta HttpService
            return game:HttpGet(url)
        end
    end)
    
    if sucesso and resultado then
        return resultado
    end
    return nil
end

-- FUNÇÃO PARA VALIDAR KEY (adaptada)
local function ValidarKey(key)
    local url = SiteURL .. "/?api=true&key=" .. key
    local resposta = FazerRequisicao(url)
    
    if resposta then
        -- Tenta decodificar o JSON
        local sucesso, dados = pcall(function()
            return game:GetService("HttpService"):JSONDecode(resposta)
        end)
        
        if sucesso and dados and dados.valid then
            return true, dados
        end
    end
    return false, nil
end

-- CRIAR INTERFACE (igual antes)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ORKeySystem"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- FUNDO
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.BackgroundTransparency = 0.5
Background.Parent = ScreenGui

-- JANELA PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🔑 OR's KEY SYSTEM"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 30
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- SUBTÍTULO
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.Position = UDim2.new(0, 0, 0, 60)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Digite sua key para acessar"
SubTitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
SubTitle.TextSize = 16
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = MainFrame

-- CAMPO DE TEXTO
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.8, 0, 0, 40)
TextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.PlaceholderText = "OR-XXXX-XXXX"
TextBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
TextBox.TextSize = 20
TextBox.Font = Enum.Font.Code
TextBox.ClearTextOnFocus = false
TextBox.Parent = MainFrame

-- BOTÃO VALIDAR
local ValidateButton = Instance.new("TextButton")
ValidateButton.Size = UDim2.new(0.6, 0, 0, 50)
ValidateButton.Position = UDim2.new(0.2, 0, 0.55, 0)
ValidateButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ValidateButton.TextColor3 = Color3.new(1, 1, 1)
ValidateButton.Text = "🔓 VALIDAR KEY"
ValidateButton.TextSize = 20
ValidateButton.Font = Enum.Font.GothamBold
ValidateButton.Parent = MainFrame

-- STATUS
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Aguardando..."
StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- FUNÇÃO DO BOTÃO
ValidateButton.MouseButton1Click:Connect(function()
    local key = TextBox.Text
    if key == "" then
        StatusLabel.Text = "❌ Digite uma key!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
        return
    end
    
    StatusLabel.Text = "⏳ Validando..."
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    
    local valida, dados = ValidarKey(key)
    
    if valida then
        StatusLabel.Text = "✅ KEY VÁLIDA! Acesso liberado!"
        StatusLabel.TextColor3 = Color3.new(0, 1, 0)
        
        -- Salvar key
        pcall(function()
            writefile("OR_Key.txt", key)
        end)
        
        wait(2)
        ScreenGui:Destroy()
        
        -- ========================================
        -- SEU SCRIPT PRINCIPAL AQUI
        -- ========================================
        local MainGui = Instance.new("ScreenGui")
        MainGui.Name = "ORMainHub"
        MainGui.Parent = PlayerGui
        
        local MainFrame2 = Instance.new("Frame")
        MainFrame2.Size = UDim2.new(0, 500, 0, 400)
        MainFrame2.Position = UDim2.new(0.5, -250, 0.5, -200)
        MainFrame2.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        MainFrame2.BorderSizePixel = 2
        MainFrame2.BorderColor3 = Color3.new(1, 1, 1)
        MainFrame2.Active = true
        MainFrame2.Draggable = true
        MainFrame2.Parent = MainGui
        
        local MainTitle = Instance.new("TextLabel")
        MainTitle.Size = UDim2.new(1, 0, 0, 50)
        MainTitle.Position = UDim2.new(0, 0, 0, 10)
        MainTitle.BackgroundTransparency = 1
        MainTitle.Text = "🎮 HUB PRINCIPAL"
        MainTitle.TextColor3 = Color3.new(1, 1, 1)
        MainTitle.TextSize = 30
        MainTitle.Font = Enum.Font.GothamBold
        MainTitle.Parent = MainFrame2
        
        local KeyLabel = Instance.new("TextLabel")
        KeyLabel.Size = UDim2.new(1, 0, 0, 30)
        KeyLabel.Position = UDim2.new(0, 0, 0, 70)
        KeyLabel.BackgroundTransparency = 1
        KeyLabel.Text = "Key: " .. key
        KeyLabel.TextColor3 = Color3.new(0, 1, 0)
        KeyLabel.TextSize = 16
        KeyLabel.Font = Enum.Font.Gotham
        KeyLabel.Parent = MainFrame2
        
        -- BOTÃO EXECUTAR
        local ExecuteBtn = Instance.new("TextButton")
        ExecuteBtn.Size = UDim2.new(0.6, 0, 0, 50)
        ExecuteBtn.Position = UDim2.new(0.2, 0, 0.4, 0)
        ExecuteBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
        ExecuteBtn.Text = "EXECUTAR"
        ExecuteBtn.TextSize = 20
        ExecuteBtn.Font = Enum.Font.GothamBold
        ExecuteBtn.Parent = MainFrame2
        
        ExecuteBtn.MouseButton1Click:Connect(function()
            print("🎯 Script executado!")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "OR's System",
                Text = "Script executado com sucesso!",
                Duration = 3
            })
        end)
        
    else
        StatusLabel.Text = "❌ Key inválida ou expirada!"
        StatusLabel.TextColor3 = Color3.new(1, 0, 0)
    end
end)

-- VERIFICAR KEY SALVA
pcall(function()
    local keySalva = readfile("OR_Key.txt")
    if keySalva and keySalva ~= "" then
        TextBox.Text = keySalva
        StatusLabel.Text = "🔑 Key salva encontrada"
        StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    end
end)

-- BOTÃO LIMPAR
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.3, 0, 0, 30)
ClearButton.Position = UDim2.new(0.35, 0, 0.9, 0)
ClearButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ClearButton.TextColor3 = Color3.new(1, 0.5, 0.5)
ClearButton.Text = "LIMPAR"
ClearButton.TextSize = 14
ClearButton.Font = Enum.Font.Gotham
ClearButton.Parent = MainFrame

ClearButton.MouseButton1Click:Connect(function()
    pcall(function()
        delfile("OR_Key.txt")
    end)
    TextBox.Text = ""
    StatusLabel.Text = "Key removida!"
    StatusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
end)

print("✅ OR's Key System carregado (Versão Delta)!")

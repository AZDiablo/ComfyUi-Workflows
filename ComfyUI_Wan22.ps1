# Launch_ComfyUI_Wan22.ps1
# Launches ComfyUI with Wan22 environment for video generation

# Define paths
$venvPath = "D:\ComfyUI_Wan22"
$comfyUIPath = "D:\comfyui"

# Check if virtual environment exists
if (-Not (Test-Path $venvPath)) {
    Write-Host "Virtual environment not found at: $venvPath" -ForegroundColor Red
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv $venvPath
    
    Write-Host "Virtual environment created. Installing dependencies..." -ForegroundColor Yellow
    & "$venvPath\Scripts\Activate.ps1"
    Set-Location $comfyUIPath
    
    # Install PyTorch with CUDA support (CRITICAL: must use --index-url)
    Write-Host "Installing PyTorch with CUDA support..." -ForegroundColor Cyan
    pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu118
    
    Write-Host "Installing ComfyUI requirements..." -ForegroundColor Cyan
    pip install -r requirements.txt
    
    Write-Host "Dependencies installed!" -ForegroundColor Green
}

# Check if ComfyUI folder exists
if (-Not (Test-Path $comfyUIPath)) {
    Write-Error "ComfyUI folder not found: $comfyUIPath"
    exit 1
}

# Check if WanVideoWrapper is installed
$wanWrapperPath = "$comfyUIPath\custom_nodes\ComfyUI-WanVideoWrapper"
if (-Not (Test-Path $wanWrapperPath)) {
    Write-Host "WanVideoWrapper not found. Installing..." -ForegroundColor Yellow
    Set-Location "$comfyUIPath\custom_nodes"
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
    
    if (Test-Path "$wanWrapperPath\requirements.txt") {
        Write-Host "Installing WanVideoWrapper requirements..." -ForegroundColor Cyan
        & "$venvPath\Scripts\Activate.ps1"
        Set-Location $wanWrapperPath
        pip install -r requirements.txt
    }
    Write-Host "✓ WanVideoWrapper installed!" -ForegroundColor Green
} else {
    Write-Host "✓ WanVideoWrapper found" -ForegroundColor Green
}

# Activate the virtual environment
$activateScript = "$venvPath\Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    Write-Host "Activating Wan22 environment..." -ForegroundColor Cyan
    & $activateScript
} else {
    Write-Error "Activation script not found: $activateScript"
    exit 1
}

# Navigate to ComfyUI and launch
Set-Location $comfyUIPath
Write-Host "Launching ComfyUI with Wan22 environment..." -ForegroundColor Green
python main.py
# 🪟 Configuração do Ambiente Windows

Este guia é específico para usuários Windows que estão desenvolvendo o compilador C-.

## 🎯 Recomendação Principal

**Use Git Bash** - É a opção mais simples e eficiente para este projeto no Windows.

## 📋 Pré-requisitos

### 1. Git for Windows
- **Download**: https://git-scm.com/download/win
- **Inclui**: Git Bash, que é um terminal Unix-like para Windows
- **Por que**: Os scripts do projeto são em bash e funcionam perfeitamente

### 2. CMake
```bash
# Via Chocolatey (recomendado)
choco install cmake

# Ou download direto: https://cmake.org/download/
```

### 3. Compilador C (MinGW-w64)
```bash
# Via Chocolatey
choco install mingw

# Ou via MSYS2 (mais completo)
# Download: https://www.msys2.org/
# No terminal MSYS2:
pacman -S mingw-w64-x86_64-gcc
pacman -S mingw-w64-x86_64-make
```

### 4. Flex e Bison
```bash
# Via Chocolatey
choco install winflexbison

# Ou via MSYS2
pacman -S mingw-w64-x86_64-flex
pacman -S mingw-w64-x86_64-bison
```

### 5. Python
```bash
# Via Chocolatey
choco install python

# Ou download: https://www.python.org/downloads/
```

## 🚀 Instalação Rápida (Chocolatey)

Se você não tem Chocolatey, instale primeiro:
```powershell
# Executar no PowerShell como Administrador
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Depois instale tudo de uma vez:
```powershell
choco install git cmake mingw winflexbison python -y
```

## 🔧 Configuração do PATH

Após a instalação, adicione ao PATH do Windows:
```
C:\ProgramData\chocolatey\bin
C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin
```

## 📝 VS Code Extensions

### Extensões Essenciais
```json
{
    "recommendations": [
        "ms-vscode.cpptools",           // C/C++ IntelliSense
        "ms-vscode.cmake-tools",        // CMake Tools
        "ms-vscode.cpptools-extension-pack", // C++ Extension Pack
        "ms-vscode.powershell",         // PowerShell
        "ms-vscode.vscode-json",        // JSON support
        "ms-vscode.vscode-markdown",    // Markdown support
        "eamodio.gitlens",              // Git integration
        "ms-vscode.hexeditor",          // Hex editor (útil para debug)
        "ms-vscode.vscode-json"         // JSON support
    ]
}
```

### Configuração do VS Code
```json
// settings.json
{
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "terminal.integrated.profiles.windows": {
        "Git Bash": {
            "path": "C:\\Program Files\\Git\\bin\\bash.exe",
            "args": ["--login", "-i"]
        }
    },
    "cmake.configureOnOpen": true,
    "cmake.buildDirectory": "${workspaceFolder}/build",
    "files.associations": {
        "*.l": "lex",
        "*.y": "yacc",
        "*.cm": "c"
    }
}
```

## 🎮 Terminais Disponíveis

### 1. Git Bash (Recomendado)
```bash
# Abrir Git Bash
# Navegar para o projeto
cd /c/Users/Jonatan/Desktop/ITA/8°\ Semestre/CTC41/labctc41250806_1601

# Criar build
mkdir build
cd build

# Compilar
cmake .. -DDOPARSE=FALSE
make
```

### 2. PowerShell
```powershell
# No PowerShell
cd "C:\Users\Jonatan\Desktop\ITA\8° Semestre\CTC41\labctc41250806_1601"
mkdir build
cd build
cmake .. -DDOPARSE=FALSE
make
```

### 3. VS Code Terminal
- Pressione `Ctrl + `` (backtick)
- Selecione "Git Bash" no dropdown
- Execute os comandos normalmente

## 🔍 Verificação da Instalação

Execute no Git Bash:
```bash
# Verificar versões
cmake --version
gcc --version
flex --version
bison --version
python --version
make --version
```

## ⚠️ Problemas Comuns

### 1. "make: command not found"
```bash
# Instalar make via Chocolatey
choco install make

# Ou usar mingw32-make
mingw32-make
```

### 2. "cmake: command not found"
- Verifique se CMake está no PATH
- Reinicie o terminal após instalação

### 3. "flex/bison: command not found"
- Instale winflexbison via Chocolatey
- Ou use as versões do MSYS2

### 4. Problemas de Encoding
```bash
# No Git Bash, configure encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

## 🎯 Próximos Passos

Após configurar o ambiente:
1. Leia [02-compilacao.md](02-compilacao.md)
2. Teste com [03-testes.md](03-testes.md)
3. Comece o desenvolvimento com [04-desenvolvimento.md](04-desenvolvimento.md) 
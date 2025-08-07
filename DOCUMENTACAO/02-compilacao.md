# 🔨 Compilação e Build

Este guia explica como compilar o projeto do compilador C- no Windows.

## 🎯 Visão Geral

O projeto usa **CMake** como sistema de build, que gera automaticamente os arquivos necessários a partir das especificações Flex (`.l`) e Bison (`.y`).

## 📁 Estrutura de Build

```
labctc41250806_1601/
├── src/                    # Código fonte
├── build/                  # Diretório de build (criado por você)
│   ├── lexer.c            # Gerado pelo Flex
│   ├── parser.c           # Gerado pelo Bison (se DOPARSE=TRUE)
│   ├── mycmcomp           # Executável principal
│   └── tiny               # Executável TinyC
└── CMakeLists.txt         # Configuração CMake
```

## 🚀 Primeira Compilação

### 1. Criar Diretório Build
```bash
# No Git Bash
cd /c/Users/Jonatan/Desktop/ITA/8°\ Semestre/CTC41/labctc41250806_1601
mkdir build
cd build
```

### 2. Configurar CMake
```bash
# Para análise apenas léxica (mais rápido para desenvolvimento)
cmake .. -DDOPARSE=FALSE

# Para compilador completo
cmake .. -DDOPARSE=TRUE
```

### 3. Compilar
```bash
make
```

## ⚙️ Opções de Compilação

### DOPARSE=FALSE (Análise Apenas Léxica)
```bash
cmake .. -DDOPARSE=FALSE
make
```
- ✅ Mais rápido para debug
- ✅ Apenas análise léxica
- ✅ Ideal para desenvolvimento inicial

### DOPARSE=TRUE (Compilador Completo)
```bash
cmake .. -DDOPARSE=TRUE
make
```
- ✅ Análise léxica, sintática e semântica
- ✅ Geração de código TM
- ✅ Funcionalidade completa

### Diretório de Fontes Personalizado
```bash
cmake .. -DCES41_SRC:FILEPATH=/caminho/para/suas/fontes
```

## 🎮 Scripts de Compilação Rápida

### Para Aluno (Apenas Léxica)
```bash
# No diretório raiz do projeto
./compLabAluno.bash
```

### Para Professor (Completo)
```bash
# No diretório raiz do projeto
./compLabProf.bash
```

## 📋 Comandos Make Disponíveis

Após a compilação, você pode usar:

```bash
# Recompilar
make

# Limpar build
make clean

# Executar testes
make runmycmcomp

# Comparar diferenças
make rundiff

# Comparação detalhada
make ddiff

# Comparação apenas léxica
make lexdiff
```

## 🔍 Verificação da Compilação

### 1. Verificar Executáveis
```bash
# No diretório build/
ls -la mycmcomp
ls -la tiny
```

### 2. Testar Execução
```bash
# Testar compilador C-
./mycmcomp ../example/mdc.cm

# Testar compilador TinyC
./tiny ../TinyGeracaoCodigo/teste.tny
```

### 3. Verificar Arquivos Gerados
```bash
# Verificar arquivos do Flex/Bison
ls -la lexer.c
ls -la parser.c  # (se DOPARSE=TRUE)
```

## ⚠️ Problemas Comuns

### 1. "CMake Error: Could not find BISON"
```bash
# Instalar Bison
choco install winflexbison

# Ou verificar se está no PATH
which bison
```

### 2. "CMake Error: Could not find FLEX"
```bash
# Instalar Flex
choco install winflexbison

# Ou verificar se está no PATH
which flex
```

### 3. "make: command not found"
```bash
# Instalar make
choco install make

# Ou usar mingw32-make
mingw32-make
```

### 4. "undefined reference to yylex"
```bash
# Limpar e recompilar
make clean
cmake .. -DDOPARSE=FALSE
make
```

### 5. Arquivos Gerados no Diretório Errado
```bash
# NUNCA compile manualmente Flex/Bison
# Sempre use CMake

# Se você compilou manualmente, apague os arquivos gerados:
rm -f src/lex.yy.c src/parser.c src/parser.h

# Depois recompile com CMake
```

## 🔧 Configuração Avançada

### CMake com Debug
```bash
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Debug
make
```

### CMake com Otimização
```bash
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Release
make
```

### Verbose Make
```bash
make VERBOSE=1
```

## 📊 Saídas da Compilação

### Arquivos Gerados
- `mycmcomp`: Compilador C- principal
- `tiny`: Compilador TinyC de referência
- `lexer.c`: Scanner gerado pelo Flex
- `parser.c`: Parser gerado pelo Bison
- `parser.h`: Headers do parser

### Logs de Compilação
```bash
# Ver logs detalhados
make 2>&1 | tee build.log

# Ver apenas erros
make 2>&1 | grep -i error
```

## 🎯 Próximos Passos

Após compilar com sucesso:
1. Execute os testes: [03-testes.md](03-testes.md)
2. Comece o desenvolvimento: [04-desenvolvimento.md](04-desenvolvimento.md)
3. Entenda a linguagem: [05-linguagem-cminus.md](05-linguagem-cminus.md) 
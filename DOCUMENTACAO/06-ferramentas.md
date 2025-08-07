# 🛠️ Ferramentas do Projeto

Este guia explica as ferramentas utilizadas no desenvolvimento do compilador C-.

## 🎯 Visão Geral das Ferramentas

O projeto utiliza várias ferramentas especializadas:
- **Flex**: Gerador de analisadores léxicos
- **Bison**: Gerador de analisadores sintáticos
- **CMake**: Sistema de build
- **GCC**: Compilador C
- **TM**: Máquina virtual para execução

## 🔍 Flex (Fast Lexical Analyzer Generator)

### O que é
Flex é um gerador de analisadores léxicos que converte especificações de padrões em código C.

### Arquivo de Especificação (`src/cminus.l`)
```lex
%option noyywrap

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
char tokenString[MAXTOKENLEN+1];
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%
"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
.               {return ERROR;}
%%
```

### Estrutura do Arquivo Flex
1. **Seção de Definições**: Padrões e opções
2. **Seção de Regras**: Padrões e ações
3. **Seção de Código**: Funções auxiliares

### Comandos Flex
```bash
# Gerar analisador léxico
flex src/cminus.l

# Verificar sintaxe
flex -t src/cminus.l

# Gerar com debug
flex -d src/cminus.l
```

### Instalação no Windows
```bash
# Via Chocolatey
choco install winflexbison

# Via MSYS2
pacman -S mingw-w64-x86_64-flex
```

## 🌳 Bison (Parser Generator)

### O que é
Bison é um gerador de analisadores sintáticos que converte gramáticas em código C.

### Arquivo de Especificação (`src/cminus.y`)
```yacc
%{
#include "globals.h"
#include "util.h"
#include "parse.h"
#include "scan.h"
#include "analyze.h"
#include "cgen.h"
%}

%union {
    TreeNode * tree;
    int opval;
}

%token <tree> IF THEN ELSE END REPEAT UNTIL READ WRITE
%token <opval> ASSIGN EQ LT PLUS MINUS TIMES OVER LPAREN RPAREN SEMI
%token <tree> NUM ID

%type <tree> stmt stmt-seq exp
%type <tree> if-stmt repeat-stmt assign-stmt read-stmt write-stmt

%%
program : stmt-seq
        ;

stmt-seq : stmt-seq stmt
        | stmt
        ;
%%
```

### Estrutura do Arquivo Bison
1. **Seção de Declarações**: Tokens, tipos, precedência
2. **Seção de Gramática**: Regras de produção
3. **Seção de Código**: Funções auxiliares

### Comandos Bison
```bash
# Gerar analisador sintático
bison -d src/cminus.y

# Verificar gramática
bison -v src/cminus.y

# Gerar com debug
bison -t src/cminus.y
```

### Instalação no Windows
```bash
# Via Chocolatey
choco install winflexbison

# Via MSYS2
pacman -S mingw-w64-x86_64-bison
```

## 🔨 CMake (Build System)

### O que é
CMake é um sistema de build cross-platform que gera arquivos de build para diferentes plataformas.

### Arquivo de Configuração (`CMakeLists.txt`)
```cmake
cmake_minimum_required(VERSION 3.10)
project(ces41lex VERSION 0.1 LANGUAGES C)

SET(DOPARSE TRUE CACHE BOOL "if false, bison is not used")

if(DOPARSE) 
   find_package(BISON) 
endif()
find_package(FLEX)

FLEX_TARGET(scanner ${CES41_SRC}/cminus.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c)
if(DOPARSE) 
  BISON_TARGET(myparser ${CES41_SRC}/cminus.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c)
  ADD_FLEX_BISON_DEPENDENCY(scanner myparser)
endif()
```

### Comandos CMake
```bash
# Configurar projeto
cmake .. -DDOPARSE=FALSE

# Configurar com debug
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Debug

# Configurar com otimização
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Release
```

### Instalação no Windows
```bash
# Via Chocolatey
choco install cmake

# Download direto
# https://cmake.org/download/
```

## 🖥️ Máquina Virtual TM

### O que é
TM (Tiny Machine) é uma máquina virtual simples que executa código assembly gerado pelo compilador.

### Arquivo Principal (`tm.c`)
```c
// Estrutura da máquina virtual
typedef struct {
    int opcode;
    int r;
    int d;
    int s;
} Instruction;

// Registradores
int pc = 0;
int bp = 1;
int sp = 0;
int r[8];
int memory[1000];
```

### Instruções TM Suportadas
```assembly
LD   r, d(s)    // Load: r := memory[d + s]
ST   r, d(s)    // Store: memory[d + s] := r
LDA  r, d(s)    // Load Address: r := d + s
LDC  r, d(s)    // Load Constant: r := d
JLT  r, d(s)    // Jump if Less Than
JLE  r, d(s)    // Jump if Less or Equal
JGT  r, d(s)    // Jump if Greater Than
JGE  r, d(s)    // Jump if Greater or Equal
JEQ  r, d(s)    // Jump if Equal
JNE  r, d(s)    // Jump if Not Equal
```

### Execução
```bash
# Compilar máquina virtual
gcc tm.c -o tm

# Executar código TM
./tm code.tm

# Executar com entrada
echo "5 3" | ./tm code.tm
```

## 🔧 GCC (GNU Compiler Collection)

### O que é
GCC é o compilador C padrão usado para compilar o código gerado pelo Flex e Bison.

### Comandos GCC
```bash
# Compilar arquivo único
gcc -o programa programa.c

# Compilar com debug
gcc -g -o programa programa.c

# Compilar com otimização
gcc -O2 -o programa programa.c

# Compilar com warnings
gcc -Wall -Wextra -o programa programa.c
```

### Instalação no Windows
```bash
# Via Chocolatey
choco install mingw

# Via MSYS2
pacman -S mingw-w64-x86_64-gcc
```

## 📊 Ferramentas de Análise

### 1. GDB (GNU Debugger)
```bash
# Compilar com debug
gcc -g -o programa programa.c

# Executar com GDB
gdb programa

# Comandos GDB
(gdb) break main
(gdb) run
(gdb) next
(gdb) print variable
(gdb) continue
```

### 2. Valgrind (se disponível)
```bash
# Verificar vazamentos de memória
valgrind --leak-check=full ./programa

# Verificar erros de memória
valgrind --tool=memcheck ./programa
```

### 3. Make
```bash
# Compilar projeto
make

# Limpar build
make clean

# Recompilar
make rebuild
```

## 🔍 Ferramentas de Teste

### 1. Scripts Bash
```bash
# Executar testes
./scripts/runcmcomp

# Comparar resultados
./scripts/rundiff

# Comparação detalhada
./scripts/rundetaildiff
```

### 2. Python
```bash
# Analisar diferenças
python compare_diffs.py

# Processar logs
python process_logs.py
```

### 3. Diff
```bash
# Comparar arquivos
diff arquivo1.txt arquivo2.txt

# Comparar diretórios
diff -r dir1/ dir2/

# Ignorar espaços
diff -w arquivo1.txt arquivo2.txt
```

## 🎨 Ferramentas de Desenvolvimento

### 1. VS Code Extensions
```json
{
    "recommendations": [
        "ms-vscode.cpptools",           // C/C++ IntelliSense
        "ms-vscode.cmake-tools",        // CMake Tools
        "ms-vscode.cpptools-extension-pack", // C++ Extension Pack
        "ms-vscode.hexeditor",          // Hex Editor
        "ms-vscode.vscode-json",        // JSON support
        "eamodio.gitlens",              // Git integration
        "ms-vscode.vscode-markdown"     // Markdown support
    ]
}
```

### 2. Configuração do VS Code
```json
// .vscode/settings.json
{
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "cmake.configureOnOpen": true,
    "cmake.buildDirectory": "${workspaceFolder}/build",
    "files.associations": {
        "*.l": "lex",
        "*.y": "yacc",
        "*.cm": "c"
    }
}
```

### 3. Git
```bash
# Inicializar repositório
git init

# Adicionar arquivos
git add .

# Fazer commit
git commit -m "Implementação inicial"

# Verificar status
git status
```

## 🔧 Configuração do Ambiente

### 1. PATH do Windows
```bash
# Adicionar ao PATH
C:\ProgramData\chocolatey\bin
C:\ProgramData\chocolatey\lib\mingw\tools\install\mingw64\bin
```

### 2. Variáveis de Ambiente
```bash
# No Git Bash
export PATH="/c/ProgramData/chocolatey/bin:$PATH"
export PATH="/c/ProgramData/chocolatey/lib/mingw/tools/install/mingw64/bin:$PATH"
```

### 3. Verificação de Instalação
```bash
# Verificar versões
cmake --version
gcc --version
flex --version
bison --version
make --version
```

## ⚠️ Problemas Comuns

### 1. Flex/Bison não encontrados
```bash
# Verificar instalação
which flex
which bison

# Reinstalar se necessário
choco uninstall winflexbison
choco install winflexbison
```

### 2. CMake não encontra Flex/Bison
```bash
# Verificar PATH
echo $PATH

# Configurar manualmente
cmake .. -DFLEX_EXECUTABLE=/caminho/para/flex -DBISON_EXECUTABLE=/caminho/para/bison
```

### 3. GCC não encontrado
```bash
# Verificar instalação
which gcc

# Instalar MinGW
choco install mingw
```

## 📚 Referências

### Documentação Oficial
- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)
- [CMake Documentation](https://cmake.org/documentation/)
- [GCC Documentation](https://gcc.gnu.org/onlinedocs/)

### Tutoriais
- [Flex Tutorial](https://westes.github.io/flex/manual/Simple-Examples.html)
- [Bison Tutorial](https://www.gnu.org/software/bison/manual/bison.html#Simple-Examples)
- [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/)

## 🎯 Próximos Passos

Após entender as ferramentas:
1. Veja exemplos práticos: [07-exemplos.md](07-exemplos.md)
2. Comece o desenvolvimento: [04-desenvolvimento.md](04-desenvolvimento.md)
3. Execute os testes: [03-testes.md](03-testes.md) 
# 🔧 Desenvolvimento

Este guia explica como desenvolver e modificar o compilador C- no Windows.

## 🎯 Visão Geral do Desenvolvimento

O projeto está estruturado em módulos bem definidos:
- **Análise Léxica**: Reconhecimento de tokens
- **Análise Sintática**: Construção da árvore sintática
- **Análise Semântica**: Verificação de tipos e declarações
- **Geração de Código**: Produção de código TM

## 📁 Estrutura do Código Fonte

```
src/
├── cminus.l           # Especificação Flex (análise léxica)
├── cminus.y           # Especificação Bison (análise sintática)
├── main.c             # Função principal
├── globals.h          # Definições globais e estruturas
├── util.c/h           # Funções utilitárias
├── scan.h             # Cabeçalhos para scanner
├── parse.h            # Cabeçalhos para parser
├── analyze.c/h        # Análise semântica
├── cgen.c/h           # Geração de código
├── symtab.c/h         # Tabela de símbolos
└── code.c/h           # Estruturas de código
```

## 🔍 Análise Léxica (`src/cminus.l`)

### Estrutura do Arquivo Flex
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

### Modificações Comuns
- **Adicionar palavras reservadas**: Adicione na seção `%%`
- **Modificar padrões**: Altere as definições no início
- **Adicionar ações**: Modifique as ações após `%%`

## 🌳 Análise Sintática (`src/cminus.y`)

### Estrutura do Arquivo Bison
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

### Modificações Comuns
- **Adicionar regras**: Defina novas produções
- **Modificar tokens**: Altere as declarações `%token`
- **Adicionar tipos**: Use `%type` para novos tipos

## 🧠 Análise Semântica (`src/analyze.c`)

### Funções Principais
```c
// Construção da tabela de símbolos
void buildSymtab(TreeNode * tree);

// Verificação de tipos
void typeCheck(TreeNode * tree);

// Verificação de declarações
void checkNode(TreeNode * tree);
```

### Modificações Comuns
- **Adicionar verificações**: Implemente novas funções de verificação
- **Modificar tipos**: Altere as regras de verificação de tipos
- **Adicionar escopos**: Implemente controle de escopo

## 💻 Geração de Código (`src/cgen.c`)

### Funções Principais
```c
// Geração de código para expressões
void codeGen(TreeNode * tree);

// Geração de código para declarações
void codeDecl(TreeNode * tree);

// Geração de código para comandos
void codeStmt(TreeNode * tree);
```

### Modificações Comuns
- **Adicionar instruções**: Implemente novas instruções TM
- **Otimizar código**: Melhore a geração de código
- **Adicionar funções**: Implemente suporte a funções

## 🗃️ Tabela de Símbolos (`src/symtab.c`)

### Estruturas Principais
```c
typedef struct lineListRec {
    int lineno;
    struct lineListRec * next;
} * LineList;

typedef struct bucketListRec {
    char * name;
    LineList lines;
    TreeNode * treeNode;
    struct bucketListRec * next;
} * BucketList;
```

### Funções Principais
```c
// Inserir símbolo
void st_insert(char * name, int lineno, int loc, ExpType type);

// Buscar símbolo
int st_lookup(char * name);

// Imprimir tabela
void printSymTab(FILE * listing);
```

## 🔧 Debug e Logging

### Flags de Debug
```c
extern int EchoSource;    // Ecoa código fonte
extern int TraceScan;     // Mostra tokens
extern int TraceParse;    // Mostra árvore sintática
extern int TraceAnalyze;  // Mostra tabela de símbolos
extern int TraceCode;     // Mostra geração de código
```

### Habilitar Debug
```bash
# No Git Bash
export TraceScan=1
export TraceParse=1
export TraceAnalyze=1
export TraceCode=1

# Executar com debug
./mycmcomp ../example/mdc.cm
```

## 🛠️ Ferramentas de Desenvolvimento

### VS Code Extensions para C
```json
{
    "recommendations": [
        "ms-vscode.cpptools",           // IntelliSense C/C++
        "ms-vscode.cmake-tools",        // CMake Tools
        "ms-vscode.cpptools-extension-pack", // C++ Extension Pack
        "ms-vscode.hexeditor",          // Hex Editor
        "ms-vscode.vscode-json",        // JSON support
        "eamodio.gitlens",              // Git integration
        "ms-vscode.vscode-markdown"     // Markdown support
    ]
}
```

### Configuração do VS Code
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
    },
    "C_Cpp.default.configurationProvider": "ms-vscode.cmake-tools"
}
```

## 🔄 Fluxo de Desenvolvimento

### 1. Modificar Código
```bash
# Editar arquivos fonte
code src/cminus.l
code src/cminus.y
code src/analyze.c
```

### 2. Recompilar
```bash
# No diretório build/
make clean
make
```

### 3. Testar
```bash
# Executar testes
make runmycmcomp

# Verificar diferenças
make rundiff
```

### 4. Debug
```bash
# Executar com debug
export TraceScan=1
./mycmcomp ../example/mdc.cm
```

## ⚠️ Boas Práticas

### 1. Sempre Use CMake
```bash
# ✅ Correto
cmake .. -DDOPARSE=FALSE
make

# ❌ Incorreto
flex src/cminus.l
bison src/cminus.y
gcc *.c -o mycmcomp
```

### 2. Teste Extensivamente
```bash
# Execute todos os testes
make runmycmcomp

# Verifique diferenças
make rundiff
```

### 3. Use Debug Flags
```bash
# Para desenvolvimento
export TraceScan=1
export TraceParse=1
```

### 4. Mantenha Compatibilidade
- Suas saídas devem corresponder aos arquivos em `output/`
- Não quebre testes existentes
- Documente mudanças significativas

## 🔍 Debug Avançado

### 1. GDB (GNU Debugger)
```bash
# Compilar com debug
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Debug
make

# Executar com GDB
gdb ./mycmcomp
(gdb) run ../example/mdc.cm
(gdb) break main
(gdb) continue
```

### 2. Valgrind (se disponível)
```bash
# Verificar vazamentos de memória
valgrind --leak-check=full ./mycmcomp ../example/mdc.cm
```

### 3. Logs Detalhados
```bash
# Executar com log completo
./mycmcomp ../example/mdc.cm 2>&1 | tee debug.log

# Analisar erros
grep -i error debug.log
grep -i warning debug.log
```

## 📚 Referências

### Documentação Flex/Bison
- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)

### Estruturas de Dados
- `src/globals.h`: Definições de estruturas
- `src/util.c`: Funções utilitárias
- `TinyGeracaoCodigo/`: Implementação de referência

## 🎯 Próximos Passos

Após entender o desenvolvimento:
1. Leia sobre a linguagem: [05-linguagem-cminus.md](05-linguagem-cminus.md)
2. Entenda as ferramentas: [06-ferramentas.md](06-ferramentas.md)
3. Veja exemplos práticos: [07-exemplos.md](07-exemplos.md) 
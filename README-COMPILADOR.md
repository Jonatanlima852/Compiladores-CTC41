# 🚀 Compilador C- - Guia Completo WSL/Ubuntu

> **Projeto CES41 - Compiladores | ITA**  
> Implementação de compilador para linguagem C- em ambiente WSL/Ubuntu

## 📋 Índice

<details>
<summary><strong>🔧 Configuração do Ambiente</strong></summary>

### Pré-requisitos WSL/Ubuntu

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar ferramentas essenciais
sudo apt install -y build-essential cmake flex bison python3 git

# Verificar instalações
cmake --version
gcc --version
flex --version
bison --version
```

### Estrutura do Projeto
```
labctc41250806_1601/
├── src/                    # Código fonte do compilador
│   ├── cminus.l           # Especificação léxica (Flex)
│   ├── cminus.y           # Especificação sintática (Bison) 
│   ├── main.c             # Programa principal
│   ├── globals.h          # Definições globais
│   └── util.c/h           # Utilitários
├── example/               # Arquivos de teste (.cm)
├── output/                # Saídas esperadas
├── build/                 # Diretório de compilação
└── CMakeLists.txt         # Configuração CMake
```

</details>

<details>
<summary><strong>📝 Linguagem C-</strong></summary>

### Características da Linguagem

**Tipos:** `int`, `void`  
**Operadores:** `:=` (atribuição), `=` (igualdade), `<`, `+`, `-`, `*`, `/`  
**Estruturas:** `if-then-else-end`, `repeat-until`  
**E/S:** `read`, `write`  

### Exemplo Básico
```c
/* Cálculo de MDC */
int gcd(int u, int v) {
    if (v = 0) then
        return u;
    else
        return gcd(v, u - u / v * v);
    end
}

void main(void) {
    int x, y;
    x := 48;
    y := 18;
    write gcd(x, y);
}
```

### Diferenças do C Padrão
| C- | C Padrão |
|----|----------|
| `:=` | `=` |
| `=` | `==` |
| `if-then-else-end` | `if-else` |
| `repeat-until` | `do-while` |

</details>

## 🎯 Implementação por Fases

### 🔤 **Fase 1: Analisador Léxico**

<details>
<summary><strong>Configuração e Implementação</strong></summary>

#### Compilação Apenas Léxica
```bash
# Criar diretório de build
mkdir -p build && cd build

# Configurar CMake apenas para análise léxica
cmake .. -DDOPARSE=FALSE

# Compilar
make

# Testar analisador léxico
./mycmcomp ../example/mdc.cm
```

#### Arquivo `src/cminus.l` - Estrutura Base
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
"end"           {return END;}
"repeat"        {return REPEAT;}
"until"         {return UNTIL;}
"read"          {return READ;}
"write"         {return WRITE;}
"int"           {return INT;}
"void"          {return VOID;}
"return"        {return RETURN;}
{number}        {return NUM;}
{identifier}    {return ID;}
":="            {return ASSIGN;}
"="             {return EQ;}
"<"             {return LT;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
","             {return COMMA;}
"{"             {return LBRACE;}
"}"             {return RBRACE;}
"["             {return LBRACKET;}
"]"             {return RBRACKET;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"/*"            {
                  char c;
                  do {
                    c = input();
                    if (c == EOF) break;
                    if (c == '\n') lineno++;
                  } while (c != '*' || input() != '/');
                }
.               {return ERROR;}
%%
```

#### Testes da Fase Léxica
```bash
# Executar todos os testes léxicos
make runmycmcomp

# Comparar apenas saída léxica
make lexdiff

# Testar arquivo específico
./mycmcomp ../example/mdc.cm ../detailonlylex/mdc_lex.out
```

**Saída Esperada:**
```
1: reserved word: int
1: ID, name= gcd
1: (
1: reserved word: int
1: ID, name= u
...
```

</details>

### 🌳 **Fase 2: Analisador Sintático**

<details>
<summary><strong>Configuração e Implementação</strong></summary>

#### Compilação com Parser
```bash
# Reconfigurar CMake com parser
cmake .. -DDOPARSE=TRUE

# Recompilar
make

# Testar com análise sintática
./mycmcomp ../example/mdc.cm
```

#### Arquivo `src/cminus.y` - Estrutura Base
```yacc
%{
#include "globals.h"
#include "util.h"
#include "parse.h"
#include "scan.h"
%}

%union {
    TreeNode * tree;
    int opval;
}

%token <tree> IF THEN ELSE END REPEAT UNTIL READ WRITE
%token <tree> INT VOID RETURN
%token <opval> ASSIGN EQ LT PLUS MINUS TIMES OVER 
%token <opval> LPAREN RPAREN SEMI COMMA LBRACE RBRACE LBRACKET RBRACKET
%token <tree> NUM ID
%token ENDFILE ERROR

%type <tree> program declaration-list declaration
%type <tree> fun-declaration var-declaration
%type <tree> params param-list param
%type <tree> compound-stmt local-declarations statement-list
%type <tree> statement expression-stmt selection-stmt iteration-stmt
%type <tree> return-stmt expression simple-expression
%type <tree> additive-expression term factor call args arg-list

%nonassoc THEN
%nonassoc ELSE
%right ASSIGN
%left EQ LT
%left PLUS MINUS
%left TIMES OVER

%%
program : declaration-list
        { savedTree = $1; }
        ;

declaration-list : declaration-list declaration
                 { 
                   TreeNode * t = $1;
                   if (t != NULL) {
                     while (t->sibling != NULL) t = t->sibling;
                     t->sibling = $2;
                     $$ = $1;
                   } else $$ = $2;
                 }
                 | declaration { $$ = $1; }
                 ;

declaration : fun-declaration { $$ = $1; }
            | var-declaration { $$ = $1; }
            ;

/* Continuar implementação das regras gramaticais... */
%%
```

#### Testes da Fase Sintática
```bash
# Verificar árvore sintática
export TraceParse=1
./mycmcomp ../example/mdc.cm

# Executar todos os testes
make runmycmcomp
make rundiff
```

**Saída Esperada:**
```
Syntax tree:
Declare function (return type "int"): gcd
  Function param (int var): u
  Function param (int var): v
  Conditional selection
    Op: ==
      Id: v
      Const: 0
    Return
      Id: u
    Return
      Function call: gcd
        ...
```

</details>

### 🔍 **Fase 3: Analisador Semântico**

<details>
<summary><strong>Implementação da Análise Semântica</strong></summary>

#### Funcionalidades a Implementar

1. **Tabela de Símbolos** (`src/symtab.c`)
2. **Verificação de Tipos** (`src/analyze.c`)
3. **Verificação de Declarações**
4. **Controle de Escopo**

#### Estruturas Principais
```c
// Tipos de símbolos
typedef enum {
    FunctionSymbol,
    VariableSymbol,
    ParameterSymbol
} SymbolType;

// Entrada da tabela de símbolos
typedef struct symbol {
    char * name;
    SymbolType symType;
    ExpType dataType;
    int location;
    struct symbol * next;
} Symbol;
```

#### Verificações Semânticas
- Variáveis declaradas antes do uso
- Tipos compatíveis em atribuições
- Função `main` definida
- Parâmetros corretos em chamadas de função
- Retorno compatível com tipo da função

#### Testes Semânticos
```bash
# Habilitar trace semântico
export TraceAnalyze=1
./mycmcomp ../example/mdc.cm

# Testar erros semânticos
./mycmcomp ../example/ser1_variable_not_declared.cm
./mycmcomp ../example/ser2_invalid_void_assignment.cm
```

**Saída Esperada (Tabela de Símbolos):**
```
Symbol table:
Variable Name  Scope     ID Type  Data Type  Line Numbers
-------------  --------  -------  ---------  -------------------------
gcd                     fun      int         1 
main                    fun      void        9 
u              gcd       var      int         1  5  6 
v              gcd       var      int         1  5  6 
x              main      var      int        11 13 15 
y              main      var      int        12 14 15 
```

</details>

### ⚙️ **Fase 4: Geração de Código**

<details>
<summary><strong>Implementação do Gerador de Código</strong></summary>

#### Máquina Virtual TM

A máquina virtual TM executa código assembly simples com:
- **Registradores**: 8 registradores de propósito geral
- **Memória**: Array de 1000 posições
- **Instruções**: Load, Store, Aritméticas, Controle

#### Instruções TM Principais
```assembly
LD   r, d(s)    # Load: r := memory[d + s]
ST   r, d(s)    # Store: memory[d + s] := r
LDA  r, d(s)    # Load Address: r := d + s
LDC  r, d(s)    # Load Constant: r := d
JLT  r, d(s)    # Jump if Less Than
JEQ  r, d(s)    # Jump if Equal
ADD  r, d(s)    # Add: r := r + memory[d + s]
SUB  r, d(s)    # Subtract: r := r - memory[d + s]
MUL  r, d(s)    # Multiply: r := r * memory[d + s]
DIV  r, d(s)    # Divide: r := r / memory[d + s]
```

#### Geração de Código (`src/cgen.c`)
```c
void codeGen(TreeNode * tree, char * codefile) {
    if (tree != NULL) {
        switch (tree->nodekind) {
            case StmtK:
                genStmt(tree);
                break;
            case ExpK:
                genExp(tree);
                break;
            default:
                break;
        }
        codeGen(tree->sibling, codefile);
    }
}
```

#### Testes de Geração
```bash
# Habilitar trace de código
export TraceCode=1
./mycmcomp ../example/mdc.cm

# Executar código TM gerado
./tm mdc.tm

# Com entrada
echo "48 18" | ./tm mdc.tm
```

**Saída Esperada (Código TM):**
```
* TINY Compilation to TM Code
* Standard prelude:
  0:     LD  6,0(0)     load maxaddress from location 0
  1:     LD  2,0(0)     load maxaddress from location 0
  2:     ST  0,0(0)     clear location 0
* End of standard prelude.
* -> Function (gcd)
  4:     ST  0,-1(2)    store return address
  5:     LDC 0,0(0)     load constant 0
  ...
```

</details>

## 🧪 Testes e Validação

<details>
<summary><strong>Sistema de Testes Completo</strong></summary>

### Execução Rápida
```bash
# Executar todos os testes
make runmycmcomp

# Comparar com resultados esperados
make rundiff

# Comparação detalhada
make ddiff

# Comparação apenas léxica
make lexdiff
```

### Arquivos de Teste

**Testes Básicos:**
- `mdc.cm` - Cálculo de MDC
- `sort.cm` - Algoritmo de ordenação
- `assign_test_code.cm` - Testes de atribuição

**Testes de Erro:**
- `invalid_ch.cm` - Caracteres inválidos
- `missing_semicolon.cm` - Erros sintáticos
- `ser1_variable_not_declared.cm` - Erros semânticos

### Debug Avançado
```bash
# Habilitar todos os traces
export TraceScan=1
export TraceParse=1
export TraceAnalyze=1
export TraceCode=1

# Executar com debug completo
./mycmcomp ../example/mdc.cm 2>&1 | tee debug.log

# Analisar erros
grep -i error debug.log
```

</details>

## ⚡ Scripts de Automação

<details>
<summary><strong>Scripts Úteis</strong></summary>

### Script de Compilação Rápida
```bash
#!/bin/bash
# compile.sh

echo "🔨 Compilando Compilador C-..."

# Limpar build anterior
rm -rf build
mkdir build && cd build

# Configurar e compilar
if [ "$1" = "lex" ]; then
    echo "📝 Modo apenas léxico"
    cmake .. -DDOPARSE=FALSE
else
    echo "🌳 Modo completo"
    cmake .. -DDOPARSE=TRUE
fi

make

if [ $? -eq 0 ]; then
    echo "✅ Compilação bem-sucedida!"
    echo "🧪 Executando testes..."
    make runmycmcomp
    make rundiff
else
    echo "❌ Erro na compilação"
    exit 1
fi
```

### Script de Teste Individual
```bash
#!/bin/bash
# test.sh <arquivo.cm>

if [ $# -ne 1 ]; then
    echo "Uso: $0 <arquivo.cm>"
    exit 1
fi

FILE="$1"
cd build

echo "🧪 Testando $FILE..."

# Executar compilador
./mycmcomp "../example/$FILE"

# Se código TM foi gerado, executar
if [ -f "${FILE%.cm}.tm" ]; then
    echo "⚙️ Executando código TM..."
    ./tm "${FILE%.cm}.tm"
fi
```

</details>

## 🚨 Problemas Comuns e Soluções

<details>
<summary><strong>Troubleshooting</strong></summary>

### Erro: "CMake não encontra Flex/Bison"
```bash
# Verificar instalação
which flex bison

# Reinstalar se necessário
sudo apt install --reinstall flex bison
```

### Erro: "undefined reference to yylex"
```bash
# Limpar e recompilar
cd build
make clean
cmake .. -DDOPARSE=FALSE
make
```

### Erro: "Permission denied"
```bash
# Dar permissões corretas
chmod +x mycmcomp tm
```

### Diferenças nos Testes
```bash
# Verificar diferenças específicas
diff -u output/mdc.out alunoout/mdc.out

# Ignorar espaços em branco
diff -w output/mdc.out alunoout/mdc.out
```

</details>

## 📚 Referências e Recursos

<details>
<summary><strong>Links Úteis</strong></summary>

### Documentação Oficial
- [Flex Manual](https://westes.github.io/flex/manual/)
- [Bison Manual](https://www.gnu.org/software/bison/manual/)
- [CMake Documentation](https://cmake.org/documentation/)

### Livro de Referência
- "Compiler Construction: Principles and Practice" - Kenneth C. Louden

### Comandos Úteis WSL/Ubuntu
```bash
# Verificar versões das ferramentas
cmake --version && gcc --version && flex --version && bison --version

# Monitorar uso de memória
top -p $(pgrep mycmcomp)

# Encontrar arquivos por extensão
find . -name "*.cm" -o -name "*.l" -o -name "*.y"
```

</details>

---

**🎓 Desenvolvido para CES41 - Compiladores | ITA**

> Este guia cobre todas as fases de implementação do compilador C-, desde a configuração inicial até a geração de código executável. Siga as fases sequencialmente para um desenvolvimento estruturado e bem-sucedido.

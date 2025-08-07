# Compilador C- (CES41 - Compiladores)

Este repositório contém um projeto de compilador para a linguagem C- desenvolvido para a disciplina CES41 (Compiladores). O projeto implementa um compilador completo que inclui análise léxica, análise sintática, análise semântica e geração de código para uma máquina virtual TM (Tiny Machine).

## 📁 Estrutura do Projeto

```
labctc41250806_1601/
├── src/                    # Código fonte principal do compilador C-
│   ├── cminus.l           # Especificação Flex para análise léxica
│   ├── main.c             # Função principal
│   ├── globals.h          # Definições globais e estruturas
│   ├── util.c/h           # Funções utilitárias
│   └── scan.h             # Cabeçalhos para scanner
├── TinyFlex/              # Implementação apenas léxica do TinyC
├── TinyGeracaoCodigo/     # Compilador TinyC completo (referência)
├── example/               # Arquivos de teste (.cm)
├── output/                # Saídas esperadas dos testes
├── detail/                # Saídas detalhadas dos testes
├── detailonlylex/         # Saídas apenas da análise léxica
├── lib/                   # Bibliotecas auxiliares
├── scripts/               # Scripts de execução e teste
└── CMakeLists.txt         # Configuração de build
```

## 🎯 Objetivo do Projeto

Implementar um compilador completo para a linguagem C-, que é um subconjunto simplificado da linguagem C. O compilador deve:

1. **Análise Léxica**: Reconhecer tokens da linguagem C-
2. **Análise Sintática**: Construir árvore sintática
3. **Análise Semântica**: Verificar tipos e declarações
4. **Geração de Código**: Produzir código para máquina virtual TM

## 🚀 Como Começar

### Pré-requisitos

- **CMake** (versão 3.10 ou superior)
- **Flex** (gerador de analisadores léxicos)
- **Bison** (gerador de analisadores sintáticos)
- **GCC** (compilador C)
- **Python** (para scripts de teste)

### Compilação

#### Para Análise Apenas Léxica (DOPARSE=FALSE)
```bash
# No diretório build/
cmake .. -DDOPARSE=FALSE
make
```

#### Para Compilador Completo (DOPARSE=TRUE)
```bash
# No diretório build/
cmake .. -DDOPARSE=TRUE
make
```

#### Scripts de Compilação Rápida
```bash
# Para aluno (apenas léxica)
./compLabAluno.bash

# Para professor (completo)
./compLabProf.bash
```

### Execução

```bash
# Executar todos os testes
make runmycmcomp

# Executar comparação de diferenças
make rundiff

# Executar comparação detalhada
make ddiff

# Executar comparação apenas léxica
make lexdiff
```

## 📝 Linguagem C-

A linguagem C- suporta os seguintes elementos:

### Palavras Reservadas
- `if`, `then`, `else`, `end`
- `repeat`, `until`
- `read`, `write`
- `int`, `void`
- `return`

### Operadores
- Atribuição: `:=`
- Comparação: `=`, `<`
- Aritméticos: `+`, `-`, `*`, `/`
- Parênteses: `(`, `)`
- Ponto e vírgula: `;`

### Estruturas
- Declaração de variáveis: `int x;`
- Declaração de funções: `int func(int x, int y)`
- Estruturas condicionais: `if (cond) then ... else ...`
- Loops: `repeat ... until (cond)`
- Comentários: `/* ... */`

## 🧪 Testes

### Arquivos de Teste

O diretório `example/` contém diversos arquivos de teste:

- **mdc.cm**: Cálculo de MDC (exemplo básico)
- **sort.cm**: Algoritmo de ordenação
- **branch_test_code.cm**: Testes de estruturas condicionais
- **function_call_test_code.cm**: Testes de chamadas de função
- **array_access_test_code.cm**: Testes de acesso a arrays
- **assign_test_code.cm**: Testes de atribuição

### Casos de Erro

O projeto inclui testes para diversos tipos de erro:

- **Erros Léxicos**: `invalid_ch.cm`, `invalid_id.cm`
- **Erros Sintáticos**: `missing_semicolon.cm`, `missing_parentheses.cm`
- **Erros Semânticos**: 
  - `ser1_variable_not_declared.cm`
  - `ser2_invalid_void_assignment.cm`
  - `ser3_invalid_decl_void_variable.cm`
  - `ser4_variable_already_declared.cm`
  - `ser5_function_not_declared.cm`
  - `ser6_main_undefined.cm`
  - `ser7_variable_name_used_for_function.cm`
  - `ser8_empty_return.cm`

### Execução de Testes

```bash
# Executar todos os testes
./scripts/runcmcomp

# Comparar saídas com resultados esperados
./scripts/rundiff

# Comparação detalhada
./scripts/rundetaildiff

# Comparação apenas léxica
./scripts/runLEXdiff
```

## 🔧 Desenvolvimento

### Estrutura do Código

#### Análise Léxica (`src/cminus.l`)
- Define padrões para reconhecimento de tokens
- Usa Flex para geração automática do scanner
- Suporta comentários, números, identificadores e palavras reservadas

#### Estruturas de Dados (`src/globals.h`)
- `TokenType`: Enumeração de todos os tipos de token
- `TreeNode`: Estrutura para árvore sintática
- Flags de debug: `TraceScan`, `TraceParse`, `TraceAnalyze`, `TraceCode`

#### Funções Utilitárias (`src/util.c`)
- `printToken()`: Imprime informações sobre tokens
- `printTree()`: Imprime árvore sintática
- Funções de debug e logging

### Modo de Desenvolvimento

Para desenvolvimento, você pode usar diferentes configurações:

```bash
# Apenas análise léxica (mais rápido para debug)
cmake .. -DDOPARSE=FALSE

# Compilador completo
cmake .. -DDOPARSE=TRUE

# Especificar diretório de fontes personalizado
cmake .. -DCES41_SRC:FILEPATH=/caminho/para/suas/fontes
```

### Debug e Logging

O compilador possui várias flags de debug:

- `EchoSource`: Ecoa o código fonte durante parsing
- `TraceScan`: Mostra tokens reconhecidos
- `TraceParse`: Mostra árvore sintática
- `TraceAnalyze`: Mostra operações da tabela de símbolos
- `TraceCode`: Mostra comentários na geração de código

## 📊 Saídas do Compilador

### Análise Léxica
```
1: reserved word: int
1: ID, name= main
1: (
1: reserved word: void
1: )
```

### Árvore Sintática
```
Syntax tree:
Declare function (return type "void"): main
    Declare int var: x
    Assign to var: x
        Const: 5
```

### Tabela de Símbolos
```
Symbol table:
Variable Name  Scope     ID Type  Data Type  Line Numbers
-------------  --------  -------  ---------  -------------------------
main                     fun      void        1 
x              main      var      int         2  3 
```

### Código TM Gerado
```
* TINY Compilation to TM Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:     LD  2,0(0) 	load maxaddress from location 0
  2:     ST  0,0(0) 	clear location 0
```

## 🛠️ Ferramentas Auxiliares

### Máquina Virtual TM
- `tm.c`: Implementação da máquina virtual TM
- Executa o código gerado pelo compilador
- Suporta operações aritméticas, de memória e controle de fluxo

### Scripts de Teste
- `compare_diffs.py`: Analisa diferenças entre saídas
- Scripts bash para automação de testes
- Geração automática de relatórios

## 📚 Referências

- **TinyFlex**: Implementação de referência para análise léxica
- **TinyGeracaoCodigo**: Compilador TinyC completo como referência
- **Documentação Flex/Bison**: Para desenvolvimento de analisadores

## 🚨 Importante

1. **Não modifique arquivos gerados**: Flex e Bison geram arquivos `.c` automaticamente
2. **Use CMake**: Não compile manualmente, sempre use o sistema de build
3. **Teste extensivamente**: Execute todos os casos de teste antes de submeter
4. **Mantenha compatibilidade**: Suas saídas devem corresponder aos arquivos em `output/`

## 🎓 Contexto Acadêmico

Este projeto faz parte da disciplina **CES41 - Compiladores** e tem como objetivo prático a implementação de um compilador completo, desde a análise léxica até a geração de código executável.

---

**Desenvolvido para CES41 - Compiladores**  
*Instituto Tecnológico de Aeronáutica (ITA)* 
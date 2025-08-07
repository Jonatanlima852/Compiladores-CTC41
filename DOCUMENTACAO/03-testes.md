# 🧪 Testes e Execução

Este guia explica como executar e testar o compilador C- no Windows.

## 🎯 Visão Geral dos Testes

O projeto inclui um sistema completo de testes que verifica:
- ✅ Análise léxica
- ✅ Análise sintática
- ✅ Análise semântica
- ✅ Geração de código
- ✅ Tratamento de erros

## 📁 Estrutura de Testes

```
labctc41250806_1601/
├── example/               # Arquivos de teste (.cm)
├── output/                # Saídas esperadas
├── detail/                # Saídas detalhadas
├── detailonlylex/         # Saídas apenas léxicas
├── scripts/               # Scripts de teste
└── build/                 # Executáveis compilados
```

## 🚀 Execução Rápida

### 1. Executar Todos os Testes
```bash
# No diretório build/
make runmycmcomp
```

### 2. Comparar com Resultados Esperados
```bash
# Comparação básica
make rundiff

# Comparação detalhada
make ddiff

# Comparação apenas léxica
make lexdiff
```

## 📋 Arquivos de Teste

### Testes Básicos
- **mdc.cm**: Cálculo de MDC (exemplo fundamental)
- **sort.cm**: Algoritmo de ordenação
- **assign_test_code.cm**: Testes de atribuição
- **branch_test_code.cm**: Estruturas condicionais
- **function_call_test_code.cm**: Chamadas de função
- **array_access_test_code.cm**: Acesso a arrays

### Testes de Erro
- **invalid_ch.cm**: Caracteres inválidos
- **invalid_id.cm**: Identificadores inválidos
- **missing_semicolon.cm**: Ponto e vírgula faltando
- **missing_parentheses.cm**: Parênteses faltando
- **missing_comma.cm**: Vírgula faltando

### Testes Semânticos (SER)
- **ser1_variable_not_declared.cm**: Variável não declarada
- **ser2_invalid_void_assignment.cm**: Atribuição inválida a void
- **ser3_invalid_decl_void_variable.cm**: Declaração inválida de variável void
- **ser4_variable_already_declared.cm**: Variável já declarada
- **ser5_function_not_declared.cm**: Função não declarada
- **ser6_main_undefined.cm**: Função main não definida
- **ser7_variable_name_used_for_function.cm**: Nome de variável usado para função
- **ser8_empty_return.cm**: Return vazio

## 🎮 Scripts de Teste

### Execução Manual
```bash
# Executar teste específico
./mycmcomp ../example/mdc.cm

# Executar com saída detalhada
./mycmcomp ../example/mdc.cm ../detail/mdc_detail.out

# Executar apenas análise léxica
./mycmcomp ../example/mdc.cm ../detailonlylex/mdc_lex.out
```

### Scripts Automatizados
```bash
# Executar todos os testes
./scripts/runcmcomp

# Comparar diferenças
./scripts/rundiff

# Comparação detalhada
./scripts/rundetaildiff

# Comparação apenas léxica
./scripts/runLEXdiff
```

## 📊 Interpretação dos Resultados

### Saída de Análise Léxica
```
1: reserved word: int
1: ID, name= main
1: (
1: reserved word: void
1: )
```
- ✅ Cada linha mostra um token reconhecido
- ✅ Formato: `linha: tipo_token: valor`

### Saída de Análise Sintática
```
Syntax tree:
Declare function (return type "void"): main
    Declare int var: x
    Assign to var: x
        Const: 5
```
- ✅ Mostra a árvore sintática construída
- ✅ Estrutura hierárquica do código

### Saída de Tabela de Símbolos
```
Symbol table:
Variable Name  Scope     ID Type  Data Type  Line Numbers
-------------  --------  -------  ---------  -------------------------
main                     fun      void        1 
x              main      var      int         2  3 
```
- ✅ Lista todos os símbolos declarados
- ✅ Mostra escopo, tipo e linhas de uso

### Saída de Código TM
```
* TINY Compilation to TM Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:     LD  2,0(0) 	load maxaddress from location 0
  2:     ST  0,0(0) 	clear location 0
```
- ✅ Código assembly para máquina virtual TM
- ✅ Instruções de memória e controle

## 🔍 Verificação de Testes

### 1. Verificar Executáveis
```bash
# No diretório build/
ls -la mycmcomp
ls -la tiny
```

### 2. Testar Compilador C-
```bash
# Teste básico
./mycmcomp ../example/mdc.cm

# Teste com erro
./mycmcomp ../example/invalid_ch.cm
```

### 3. Testar Compilador TinyC
```bash
# Teste TinyC
./tiny ../TinyGeracaoCodigo/teste.tny
```

## ⚠️ Problemas Comuns

### 1. "Permission denied"
```bash
# Dar permissão de execução
chmod +x mycmcomp
chmod +x tiny
```

### 2. "No such file or directory"
```bash
# Verificar se está no diretório correto
pwd
ls -la

# Verificar se executáveis existem
ls -la mycmcomp
ls -la tiny
```

### 3. "Segmentation fault"
```bash
# Recompilar com debug
make clean
cmake .. -DDOPARSE=TRUE -DCMAKE_BUILD_TYPE=Debug
make
```

### 4. Diferenças nos Testes
```bash
# Verificar diferenças detalhadas
make ddiff

# Verificar apenas léxica
make lexdiff

# Comparar arquivos específicos
diff output/mdc.out alunoout/mdc.out
```

## 🔧 Debug de Testes

### 1. Executar com Debug
```bash
# Habilitar flags de debug
export TraceScan=1
export TraceParse=1
export TraceAnalyze=1
export TraceCode=1

# Executar teste
./mycmcomp ../example/mdc.cm
```

### 2. Verificar Logs
```bash
# Executar com log detalhado
./mycmcomp ../example/mdc.cm 2>&1 | tee debug.log

# Analisar erros
grep -i error debug.log
grep -i warning debug.log
```

### 3. Teste Individual
```bash
# Testar arquivo específico
./mycmcomp ../example/mdc.cm > my_output.out

# Comparar com esperado
diff output/mdc.out my_output.out
```

## 📈 Análise de Performance

### 1. Tempo de Execução
```bash
# Medir tempo
time ./mycmcomp ../example/sort.cm

# Comparar com TinyC
time ./tiny ../TinyGeracaoCodigo/teste.tny
```

### 2. Uso de Memória
```bash
# No Windows, use Task Manager
# Ou PowerShell:
Get-Process mycmcomp | Select-Object ProcessName, WorkingSet
```

## 🎯 Próximos Passos

Após executar os testes:
1. Analise as diferenças se houver
2. Corrija problemas encontrados
3. Continue o desenvolvimento: [04-desenvolvimento.md](04-desenvolvimento.md)
4. Entenda a linguagem: [05-linguagem-cminus.md](05-linguagem-cminus.md) 
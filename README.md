# Compilador C- (CES41 - Compiladores)

Este repositório contém um projeto de compilador para a linguagem C- desenvolvido para a disciplina CES41 (Compiladores). O projeto implementa um compilador completo que inclui análise léxica, análise sintática, análise semântica e geração de código para uma máquina virtual TM (Tiny Machine).

## 🎯 Objetivo do Projeto

Implementar um compilador completo para a linguagem C-, que é um subconjunto simplificado da linguagem C. O compilador deve:

1. **Análise Léxica**: Reconhecer tokens da linguagem C-
2. **Análise Sintática**: Construir árvore sintática
3. **Análise Semântica**: Verificar tipos e declarações
4. **Geração de Código**: Produzir código para máquina virtual TM

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
├── DOCUMENTACAO/                # 📚 Documentação detalhada
└── CMakeLists.txt         # Configuração de build
```

## 🚀 Início Rápido (Windows)

### ⚡ Configuração Rápida
```bash
# 1. Instalar ferramentas (PowerShell como Administrador)
choco install git cmake mingw winflexbison python -y

# 2. Abrir Git Bash e navegar para o projeto
cd /c/Users/Jonatan/Desktop/ITA/8°\ Semestre/CTC41/labctc41250806_1601

# 3. Criar build e compilar
mkdir build
cd build
cmake .. -DDOPARSE=FALSE
make

# 4. Executar testes
make runmycmcomp
make rundiff
```

### 🎮 Scripts de Compilação Rápida
```bash
# Para aluno (apenas léxica)
./compLabAluno.bash

# Para professor (completo)
./compLabProf.bash
```

## 📚 Documentação Detalhada

A documentação completa está organizada na pasta `DOCUMENTACAO/`:

- **[01-ambiente-windows.md](DOCUMENTACAO/01-ambiente-windows.md)** - Configuração específica para Windows
- **[02-compilacao.md](DOCUMENTACAO/02-compilacao.md)** - Guia completo de compilação
- **[03-testes.md](DOCUMENTACAO/03-testes.md)** - Execução e interpretação de testes
- **[04-desenvolvimento.md](DOCUMENTACAO/04-desenvolvimento.md)** - Desenvolvimento e estrutura do código
- **[05-linguagem-cminus.md](DOCUMENTACAO/05-linguagem-cminus.md)** - Especificação da linguagem C-
- **[06-ferramentas.md](DOCUMENTACAO/06-ferramentas.md)** - Ferramentas utilizadas (Flex, Bison, CMake, etc.)
- **[07-exemplos.md](DOCUMENTACAO/07-exemplos.md)** - Exemplos práticos e casos de uso

## 🛠️ Pré-requisitos

- **CMake** (versão 3.10 ou superior)
- **Flex** (gerador de analisadores léxicos)
- **Bison** (gerador de analisadores sintáticos)
- **GCC** (compilador C)
- **Python** (para scripts de teste)

**💡 Recomendação**: Use **Git Bash** no Windows - é a opção mais simples e eficiente para este projeto.

## 📝 Linguagem C-

A linguagem C- suporta:
- ✅ Variáveis e tipos básicos (`int`, `void`)
- ✅ Funções com parâmetros e retorno
- ✅ Estruturas de controle (`if-then-else`, `repeat-until`)
- ✅ Arrays unidimensionais
- ✅ Operadores aritméticos e de comparação
- ✅ Comentários (`/* ... */`)

**Diferenças do C padrão:**
- Atribuição: `:=` (não `=`)
- Igualdade: `=` (não `==`)
- Estruturas: `if-then-else-end`, `repeat-until`

## 🧪 Testes

### Execução Rápida
```bash
# Executar todos os testes
make runmycmcomp

# Comparar com resultados esperados
make rundiff

# Comparação detalhada
make ddiff
```

### Arquivos de Teste
- **Básicos**: `mdc.cm`, `sort.cm`, `assign_test_code.cm`
- **Estruturas**: `branch_test_code.cm`, `function_call_test_code.cm`
- **Erros**: `invalid_ch.cm`, `missing_semicolon.cm`, `ser1_variable_not_declared.cm`

## 🔧 Desenvolvimento

### Estrutura do Código
- **`src/cminus.l`**: Especificação Flex (análise léxica)
- **`src/cminus.y`**: Especificação Bison (análise sintática)
- **`src/analyze.c`**: Análise semântica
- **`src/cgen.c`**: Geração de código TM

### Debug
```bash
# Habilitar debug
export TraceScan=1
export TraceParse=1
export TraceAnalyze=1
export TraceCode=1

# Executar com debug
./mycmcomp ../example/mdc.cm
```

## 🚨 Importante

1. **Use CMake**: Não compile manualmente Flex/Bison
2. **Git Bash**: Recomendado para Windows
3. **Teste extensivamente**: Execute todos os casos de teste
4. **Mantenha compatibilidade**: Suas saídas devem corresponder aos arquivos em `output/`

## 🎓 Contexto Acadêmico

Este projeto faz parte da disciplina **CES41 - Compiladores** e tem como objetivo prático a implementação de um compilador completo, desde a análise léxica até a geração de código executável.

---

**Desenvolvido para CES41 - Compiladores**  
*Instituto Tecnológico de Aeronáutica (ITA)* 
# 📚 Exemplos Práticos

Este guia apresenta exemplos práticos de uso do compilador C- e casos de teste.

## 🎯 Exemplos Básicos

### 1. Hello World Simples
```c
/* Programa básico */
void main(void) {
    write 42;
}
```

**Saída esperada:**
```
42
```

### 2. Cálculo de Soma
```c
/* Soma de dois números */
void main(void) {
    int x;
    int y;
    int result;
    
    x := 5;
    y := 3;
    result := x + y;
    write result;
}
```

**Saída esperada:**
```
8
```

### 3. Estrutura Condicional
```c
/* Verificar se número é positivo */
void main(void) {
    int x;
    read x;
    
    if (x < 0) then
        write -x;
    else
        write x;
    end
}
```

**Entrada:** `-5`  
**Saída esperada:** `5`

## 🔢 Exemplos com Arrays

### 1. Preencher e Imprimir Array
```c
/* Manipulação básica de array */
void main(void) {
    int arr[5];
    int i;
    
    /* Preencher array */
    i := 0;
    repeat
        arr[i] := i * 2;
        i := i + 1;
    until (i = 5)
    
    /* Imprimir array */
    i := 0;
    repeat
        write arr[i];
        i := i + 1;
    until (i = 5)
}
```

**Saída esperada:**
```
0
2
4
6
8
```

### 2. Busca em Array
```c
/* Buscar elemento em array */
void main(void) {
    int arr[5];
    int target;
    int i;
    int found;
    
    /* Preencher array */
    arr[0] := 10;
    arr[1] := 20;
    arr[2] := 30;
    arr[3] := 40;
    arr[4] := 50;
    
    /* Buscar elemento */
    target := 30;
    i := 0;
    found := 0;
    
    repeat
        if (arr[i] = target) then
            found := 1;
        end
        i := i + 1;
    until (i = 5)
    
    write found;
}
```

**Saída esperada:**
```
1
```

## 🔄 Exemplos com Loops

### 1. Fatorial
```c
/* Cálculo de fatorial */
void main(void) {
    int n;
    int result;
    int i;
    
    n := 5;
    result := 1;
    i := 1;
    
    repeat
        result := result * i;
        i := i + 1;
    until (i = n + 1)
    
    write result;
}
```

**Saída esperada:**
```
120
```

### 2. Série de Fibonacci
```c
/* Primeiros 10 números de Fibonacci */
void main(void) {
    int fib[10];
    int i;
    
    fib[0] := 0;
    fib[1] := 1;
    
    i := 2;
    repeat
        fib[i] := fib[i-1] + fib[i-2];
        i := i + 1;
    until (i = 10)
    
    /* Imprimir série */
    i := 0;
    repeat
        write fib[i];
        i := i + 1;
    until (i = 10)
}
```

**Saída esperada:**
```
0
1
1
2
3
5
8
13
21
34
```

## 🧮 Exemplos com Funções

### 1. Função Simples
```c
/* Função para calcular quadrado */
int square(int x) {
    return x * x;
}

void main(void) {
    int num;
    int result;
    
    num := 7;
    result := square(num);
    write result;
}
```

**Saída esperada:**
```
49
```

### 2. Função com Múltiplos Parâmetros
```c
/* Função para calcular máximo */
int max(int a, int b) {
    if (a < b) then
        return b;
    else
        return a;
    end
}

void main(void) {
    int x;
    int y;
    int result;
    
    x := 15;
    y := 23;
    result := max(x, y);
    write result;
}
```

**Saída esperada:**
```
23
```

### 3. Função Recursiva (MDC)
```c
/* Cálculo de MDC usando recursão */
int gcd(int u, int v) {
    if (v = 0) then
        return u;
    else
        return gcd(v, u - u / v * v);
    end
}

void main(void) {
    int x;
    int y;
    int result;
    
    x := 48;
    y := 18;
    result := gcd(x, y);
    write result;
}
```

**Saída esperada:**
```
6
```

## 🎮 Exemplos Interativos

### 1. Calculadora Simples
```c
/* Calculadora básica */
void main(void) {
    int a;
    int b;
    int op;
    int result;
    
    read a;
    read b;
    read op;
    
    if (op = 1) then
        result := a + b;
    else
        if (op = 2) then
            result := a - b;
        else
            if (op = 3) then
                result := a * b;
            else
                result := a / b;
            end
        end
    end
    
    write result;
}
```

**Entrada:** `10 5 1`  
**Saída esperada:** `15`

### 2. Jogo de Adivinhação
```c
/* Jogo simples de adivinhação */
void main(void) {
    int secret;
    int guess;
    int attempts;
    
    secret := 42;
    attempts := 0;
    
    repeat
        read guess;
        attempts := attempts + 1;
        
        if (guess < secret) then
            write 1;  /* Muito baixo */
        else
            if (guess > secret) then
                write 2;  /* Muito alto */
            else
                write 0;  /* Acertou */
            end
        end
    until (guess = secret)
    
    write attempts;
}
```

**Entrada:** `20 50 30 45 40 42`  
**Saída esperada:**
```
2
1
2
1
1
0
6
```

## ⚠️ Exemplos de Erro

### 1. Erro Léxico
```c
/* Caractere inválido */
void main(void) {
    int x;
    x := 5;
    write x@;  /* @ é inválido */
}
```

**Erro esperado:** `ERROR`

### 2. Erro Sintático
```c
/* Ponto e vírgula faltando */
void main(void) {
    int x
    x := 5;  /* Falta ; após declaração */
    write x;
}
```

**Erro esperado:** Erro de sintaxe

### 3. Erro Semântico
```c
/* Variável não declarada */
void main(void) {
    int x;
    y := 5;  /* y não foi declarada */
    write x;
}
```

**Erro esperado:** `Variable y is not declared`

## 🔍 Casos de Teste Específicos

### 1. Teste de Precedência
```c
/* Testar precedência de operadores */
void main(void) {
    int result;
    result := 2 + 3 * 4;
    write result;
}
```

**Saída esperada:** `14` (não 20)

### 2. Teste de Associatividade
```c
/* Testar associatividade */
void main(void) {
    int result;
    result := 10 - 3 - 2;
    write result;
}
```

**Saída esperada:** `5` (associatividade da esquerda)

### 3. Teste de Escopo
```c
/* Testar escopo de variáveis */
int global;
int func(int x) {
    int local;
    local := x * 2;
    return local;
}

void main(void) {
    global := 10;
    int result;
    result := func(global);
    write result;
}
```

**Saída esperada:** `20`

## 📊 Análise de Saídas

### 1. Saída de Análise Léxica
```bash
# Executar apenas análise léxica
./mycmcomp ../example/mdc.cm ../detailonlylex/mdc_lex.out
```

**Conteúdo esperado:**
```
1: reserved word: int
1: ID, name= gcd
1: (
1: reserved word: int
1: ID, name= u
1: ,
1: reserved word: int
1: ID, name= v
1: )
```

### 2. Saída de Análise Sintática
```bash
# Executar com análise sintática
./mycmcomp ../example/mdc.cm
```

**Conteúdo esperado:**
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
                Id: v
                Op: -
                    Id: u
                    Op: *
                        Op: /
                            Id: u
                            Id: v
                        Id: v
```

### 3. Saída de Tabela de Símbolos
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

### 4. Saída de Código TM
```
* TINY Compilation to TM Code
* Standard prelude:
  0:     LD  6,0(0) 	load maxaddress from location 0
  1:     LD  2,0(0) 	load maxaddress from location 0
  2:     ST  0,0(0) 	clear location 0
* End of standard prelude.
* -> Init Function (gcd)
  4:     ST  0,-1(2) 	store return address from ac
```

## 🎯 Como Executar os Exemplos

### 1. Criar Arquivo de Teste
```bash
# Criar arquivo de teste
echo 'void main(void) { write 42; }' > teste.cm
```

### 2. Compilar e Executar
```bash
# No diretório build/
./mycmcomp ../teste.cm

# Executar código TM gerado
./tm code.tm
```

### 3. Comparar com Esperado
```bash
# Comparar saída
./mycmcomp ../teste.cm > minha_saida.out
diff minha_saida.out ../output/teste.out
```

## 🔧 Debug de Exemplos

### 1. Habilitar Debug
```bash
# Habilitar todas as flags de debug
export TraceScan=1
export TraceParse=1
export TraceAnalyze=1
export TraceCode=1

# Executar com debug
./mycmcomp ../example/mdc.cm
```

### 2. Analisar Erros
```bash
# Executar com log detalhado
./mycmcomp ../example/erro.cm 2>&1 | tee debug.log

# Analisar erros
grep -i error debug.log
grep -i warning debug.log
```

### 3. Comparar com Referência
```bash
# Comparar com TinyC
./tiny ../TinyGeracaoCodigo/teste.tny
./mycmcomp ../example/mdc.cm
```

## 📚 Referências

### Exemplos de Referência
- `example/mdc.cm`: Cálculo de MDC
- `example/sort.cm`: Algoritmo de ordenação
- `TinyGeracaoCodigo/teste.tny`: Exemplo TinyC

### Documentação
- [Flex Examples](https://westes.github.io/flex/manual/Simple-Examples.html)
- [Bison Examples](https://www.gnu.org/software/bison/manual/bison.html#Simple-Examples)

## 🎯 Próximos Passos

Após entender os exemplos:
1. Comece o desenvolvimento: [04-desenvolvimento.md](04-desenvolvimento.md)
2. Execute os testes: [03-testes.md](03-testes.md)
3. Entenda as ferramentas: [06-ferramentas.md](06-ferramentas.md) 
# 📝 Linguagem C-

Este guia explica a linguagem C-, um subconjunto simplificado da linguagem C usado no projeto do compilador.

## 🎯 Visão Geral

C- é uma linguagem de programação simplificada que suporta:
- ✅ Variáveis e tipos básicos
- ✅ Funções
- ✅ Estruturas de controle
- ✅ Expressões aritméticas
- ✅ Arrays
- ✅ Comentários

## 🔤 Palavras Reservadas

### Controle de Fluxo
```c
if      // Estrutura condicional
then    // Bloco then do if
else    // Bloco else do if
end     // Fim de bloco
repeat  // Início de loop
until   // Condição de parada do loop
```

### Entrada/Saída
```c
read    // Leitura de entrada
write   // Escrita de saída
```

### Tipos
```c
int     // Tipo inteiro
void    // Tipo vazio (para funções)
```

### Funções
```c
return  // Retorno de função
```

## 🔧 Operadores

### Atribuição
```c
:=      // Atribuição (diferente do C padrão)
```

### Comparação
```c
=       // Igualdade
<       // Menor que
```

### Aritméticos
```c
+       // Adição
-       // Subtração
*       // Multiplicação
/       // Divisão
```

### Delimitadores
```c
(       // Parêntese esquerdo
)       // Parêntese direito
;       // Ponto e vírgula
,       // Vírgula
{       // Chave esquerda
}       // Chave direita
```

## 📝 Estruturas da Linguagem

### 1. Declaração de Variáveis
```c
int x;           // Variável inteira
int y, z;        // Múltiplas variáveis
int array[10];   // Array de inteiros
```

### 2. Declaração de Funções
```c
int func(int x, int y) {
    // corpo da função
    return x + y;
}

void main(void) {
    // função principal
}
```

### 3. Estruturas Condicionais
```c
if (x < 10) then
    x := x + 1;
else
    x := x - 1;
end
```

### 4. Loops
```c
repeat
    x := x - 1;
    write x;
until (x = 0)
```

### 5. Atribuições
```c
x := 5;              // Atribuição simples
y := x + 3;          // Atribuição com expressão
array[0] := 10;      // Atribuição em array
```

### 6. Expressões
```c
x + y               // Adição
x - y               // Subtração
x * y               // Multiplicação
x / y               // Divisão
(x + y) * z         // Expressões com parênteses
```

### 7. Chamadas de Função
```c
func(x, y);         // Chamada de função
result := func(x, y); // Atribuição de retorno
```

### 8. Entrada e Saída
```c
read x;             // Ler valor para x
write x;            // Escrever valor de x
write func(x, y);   // Escrever resultado de função
```

### 9. Comentários
```c
/* Este é um comentário
   que pode ocupar múltiplas linhas */

/* Comentário de uma linha */
```

## 📋 Gramática da Linguagem

### Programa
```
program → stmt-seq
```

### Sequência de Comandos
```
stmt-seq → stmt-seq stmt
         | stmt
```

### Comandos
```
stmt → if-stmt
     | repeat-stmt
     | assign-stmt
     | read-stmt
     | write-stmt
     | call-stmt
     | compound-stmt
```

### Estruturas Condicionais
```
if-stmt → if ( exp ) then stmt-seq else stmt-seq end
        | if ( exp ) then stmt-seq end
```

### Loops
```
repeat-stmt → repeat stmt-seq until ( exp )
```

### Atribuições
```
assign-stmt → ID := exp ;
            | ID [ exp ] := exp ;
```

### Entrada/Saída
```
read-stmt → read ID ;
          | read ID [ exp ] ;

write-stmt → write exp ;
```

### Chamadas de Função
```
call-stmt → call ID ( exp-list ) ;
```

### Expressões
```
exp → exp + term
    | exp - term
    | term

term → term * factor
     | term / factor
     | factor

factor → ( exp )
       | ID
       | ID [ exp ]
       | NUM
       | call ID ( exp-list )
```

## 🔍 Exemplos Práticos

### 1. Programa Básico (MDC)
```c
/* Cálculo do MDC usando algoritmo de Euclides */
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
    x := input();
    y := input();
    output(gcd(x, y));
}
```

### 2. Algoritmo de Ordenação
```c
/* Bubble Sort */
void sort(int arr[], int n) {
    int i, j, temp;
    i := 0;
    repeat
        j := 0;
        repeat
            if (arr[j] > arr[j + 1]) then
                temp := arr[j];
                arr[j] := arr[j + 1];
                arr[j + 1] := temp;
            end
            j := j + 1;
        until (j = n - 1)
        i := i + 1;
    until (i = n - 1)
}
```

### 3. Estruturas Condicionais
```c
void main(void) {
    int x;
    read x;
    
    if (x < 0) then
        write -x;
    else
        if (x = 0) then
            write 0;
        else
            write x;
        end
    end
}
```

### 4. Loops e Arrays
```c
void main(void) {
    int arr[10];
    int i;
    
    /* Preencher array */
    i := 0;
    repeat
        read arr[i];
        i := i + 1;
    until (i = 10)
    
    /* Imprimir array */
    i := 0;
    repeat
        write arr[i];
        i := i + 1;
    until (i = 10)
}
```

## ⚠️ Restrições e Limitações

### 1. Tipos
- ✅ Apenas `int` e `void`
- ❌ Não há `float`, `double`, `char`
- ❌ Não há ponteiros

### 2. Estruturas de Dados
- ✅ Arrays unidimensionais
- ❌ Não há structs, unions
- ❌ Não há ponteiros

### 3. Controle de Fluxo
- ✅ `if-then-else`
- ✅ `repeat-until`
- ❌ Não há `for`, `while`, `do-while`
- ❌ Não há `switch-case`

### 4. Funções
- ✅ Funções com parâmetros
- ✅ Retorno de valores
- ❌ Não há funções recursivas (limitado)
- ❌ Não há funções aninhadas

### 5. Operadores
- ✅ Operadores aritméticos básicos
- ✅ Operadores de comparação básicos
- ❌ Não há operadores bit a bit
- ❌ Não há operadores lógicos (`&&`, `||`, `!`)

## 🔧 Diferenças do C Padrão

| C- | C Padrão |
|----|----------|
| `:=` | `=` |
| `=` | `==` |
| `if-then-else-end` | `if-else` |
| `repeat-until` | `do-while` |
| `read/write` | `scanf/printf` |
| `input()/output()` | Funções específicas |

## 🎯 Próximos Passos

Após entender a linguagem C-:
1. Veja exemplos práticos: [07-exemplos.md](07-exemplos.md)
2. Entenda as ferramentas: [06-ferramentas.md](06-ferramentas.md)
3. Comece o desenvolvimento: [04-desenvolvimento.md](04-desenvolvimento.md) 
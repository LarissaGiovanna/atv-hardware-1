# Modelagem Display 7 segmentos
O display de 7 segmentos, consiste em sete LEDs dispostos em um padrão em forma de '8'. Cada LED é referido como um segmento, porque quando aceso, forma parte de um dígito.

Fonte: https://www.sta-eletronica.com.br/artigos/arduinos/funcionamento-de-um-display-de-7-segmentos-com-o-arduino

## Funcionamento de um display de 7 segmentos
<img src="https://www.sta-eletronica.com.br/resources/artigos/funcionamentodeumdisplayde7segmentoscomoarduino5.jpg">

Cada LED é representado por uma letra de *a* a *g*, onde se receber um sinal (1 ou HIGH), o LED respectivo é acendido.

### Combinações para acender os LEDs no display:

| Número | LEDs |
|--------|------|
|0       |a, b, c, d, e, f|
|1       |b, c   |
|2       |a, b, d, e, g |
|3       |a, b, c, d, g |
|4       |b, c, f, g |
|5       |a, c, d, f, g |
|6       |a, c, d, e, f, g |
|7       |a, b, c |
|8       |a, b, c, d, e, f, g |
|9       |a, b, c, d, f, g |

## Tabela verdade

### Entradas: `D0 D1 D2 D3` (4 bits)

| D0 | D1 | D2 | D3 | Número convertido em decimal | a | b | c | d | e | f | g | Nº no display | E (erro) |
|----|----|----|----|------------------------------|---|--|---|---|---|---|---|---------------|----------|
|0|0|0|0|0|1|1|1|1|1|1|0|0|0|
|0|0|0|1|1|0|1|1|0|0|0|0|1|0|
|0|0|1|0|2|1|1|0|0|1|0|1|2|0|
|0|0|1|1|3|1|1|1|0|0|0|1|3|0|
|0|1|0|0|4|0|1|1|0|0|1|1|4|0|
|0|1|0|1|5|1|0|1|1|0|1|1|5|0|
|0|1|1|0|6|1|0|1|1|1|1|1|6|0|
|0|1|1|1|7|1|1|1|0|0|0|0|7|0|
|1|0|0|0|8|1|1|1|1|1|1|1|8|0|
|1|0|0|1|9|1|1|1|1|0|1|1|9|0|
|1|0|1|0|10|0|0|0|0|0|0|0|-|1|
|1|0|1|1|11|0|0|0|0|0|0|0|-|1|
|1|1|0|0|12|0|0|0|0|0|0|0|-|1|
|1|1|0|1|13|0|0|0|0|0|0|0|-|1|
|1|1|1|0|14|0|0|0|0|0|0|0|-|1|
|1|1|1|1|15|0|0|0|0|0|0|0|-|1|

## Sinal de erro E
O sinal de erro E ou flag E, é um sinal indicando os casos onde os sinais recebidos são inválidos, pois não é possível exibí-los no display. No caso, as entradas que equivalem de 10 a 15, acionam o sinal E.

### Formação da expressão de E

Assumindo que as entradas `D3 D2 D1 D0` são 1 por padrão:

| Número decimal | Número em binário | Expressão álgebrica correspondente |
|----------------|-------------------|-------------------------|
|10|1010|`D3 ^ ~D2 ^ D1 ^ ~D0`|
|11|1011|`D3 ^ ~D2 ^ D1 ^ D0`|
|12|1100|`D3 ^ D2 ^ ~D1 ^ ~D0`|
|13|1101|`D3 ^ D2 ^ ~D1 ^ D0`|
|14|1110|`D3 ^ D2 ^ D1 ^ ~D0`|
|15|1111|`D3 ^ D2 ^ D1 ^ D0`|

Logo, \
`E = (D3 ^ ~D2 ^ D1 ^ ~D0) v (D3 ^ ~D2 ^ D1 ^ D0) v (D3 ^ D2 ^ ~D1 ^ ~D0) v (D3 ^ D2 ^ ~D1 ^ D0) v (D3 ^ D2 ^ D1 ^ ~D0) v (D3 ^ D2 ^ D1 ^ D0)`

### Simplificando:

#### Juntando os termos em comum:
 10 + 11 = `(D3 ^ ~D2 ^ D1 ^ ~D0) v (D3 ^ ~D2 ^ D1 ^ D0)`\
 Agrupando: `D3 ^ ~D2 ^ D1 (~D0 v D0)`

12 + 13 = `(D3 ^ D2 ^ ~D1 ^ ~D0) v (D3 ^ D2 ^ D1 ^ ~D0)`\
Agrupando: `D3 ^ D2 ^ ~D1 (~D0 v D0)`

14 + 15 = `(D3 ^ D2 ^ D1 ^ ~D0) v (D3 ^ D2 ^ D1 ^ D0)`\
Agrupando: `D3 ^ D2 ^ ~D1 (~D0 v D0)`

Logo,\
`E = (D3 ^ ~D2 ^ D1 [~D0 v D0]) v (D3 ^ D2 ^ ~D1 [~D0 v D0]) v (D3 ^ D2 ^ ~D1 [~D0 v D0])`

#### Aplicando propriedades
Aplicando a priopriedade da complementaridade da álgebra booleana, onde `A v ~A = Verdadeiro` ou `x v ~x = 1`:

```c
(~D0 v D0) = 1 //x v ~x = 1

E = (D3 ^ ~D2 ^ D1 ^ 1) v (D3 ^ D2 ^ ~D1 ^ 1) v (D3 ^ D2 ^ ~D1 ^ 1)

E = (D3 ^ ~D2 ^ D1) v (D3 ^ D2 ^ ~D1) v (D3 ^ D2 ^ ~D1) //qualquer valor multiplicado por 1 é igual a ele mesmo

//agrupando termos em comum:
E = D3 ^ ~D2 ^ D1 v D3 ^ D2
E = D3 ^ (~D2 ^ D1 v D2)

//aplicando a propriedade distributiva (A v BC) = (A v B)^(A v C):
E = D3 ^ (D2 v ~D2) ^ (D2 v D1)
E = D3 ^ (1) ^ (D2 v D1)
E = D3 ^ (D2 v D1)

//RESULTADO FINAL:
E = (D3 ^ D2) v (D3 ^ D1)
```

## Dedução algébrica dos segmentos

### *a*

1. Mapeamento dos casos onde o LED *a* fica apagado

|Caso | Expressão correpondente|
|------------|------------------------|
|1|`~D3 ^ ~D2 ^ ~D1 ^ D0`|
|4|`~D3 ^ D2 ^ ~D1 ^ ~D0`|
|E|`(D3 ^ D2) v (D3 ^ D1)`|

*OBS.: No caso E, o LED fica apagado (0) pois ele não consegue mostrar os sinais correspondentes aos números (10 a 15)*

Expressão:\
`A = (~D3 ^ ~D2 ^ ~D1 ^ D0) v (~D3 ^ D2 ^ ~D1 ^ ~D0) v ((D3 ^ D2) v (D3 ^ D1))`

#### Simplificando `A`:
```c
//aplicando a Lei de Morgan (negação):
A = ~(~D3 ^ ~D2 ^ ~D1 ^ D0) v ~(~D3 ^ D2 ^ ~D1 ^ ~D0) v ~((D3 ^ D2) v (D3 ^ D1))

//EXPRESSÂO FINAL:
A = (D3 v D2 v ~D1 v ~D0) ^ (D3 v ~D2 v D1 v D0) ^ (~D3 v ~D2) ^ (~D3 v ~D1)
```

### *b*

O segmento `b` fica aceso nos casos obtidos na tabela: `0, 1, 2, 3, 4, 7 e 8`.

| Caso | Binário | Mintermo |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|1|0001|`~D3 ^ ~D2 ^ ~D1 ^ D0`|
|2|0010|`~D3 ^ ~D2 ^ D1 ^ ~D0`|
|3|0011|`~D3 ^ ~D2 ^ D1 ^ D0`|
|4|0100|`~D3 ^ D2 ^ ~D1 ^ ~D0`|
|7|0111|`~D3 ^ D2 ^ D1 ^ D0`|
|8|1000|`D3 ^ ~D2 ^ ~D1 ^ ~D0`|

Como os demais segmentos, `b` pode ser transcrito diretamente da tabela verdade:

```c
B = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ ~D2 ^ ~D1 ^ D0)
  v (~D3 ^ ~D2 ^ D1 ^ ~D0)
  v (~D3 ^ ~D2 ^ D1 ^ D0)
  v (~D3 ^ D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ D2 ^ D1 ^ D0)
  v (D3 ^ ~D2 ^ ~D1 ^ ~D0)
```

### *c*

O segmento `c` fica aceso nos casos obtidos na tabela: `0, 1, 3, 4, 5, 6, 7 e 8`.

| Caso | Binário | Mintermo |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|1|0001|`~D3 ^ ~D2 ^ ~D1 ^ D0`|
|3|0011|`~D3 ^ ~D2 ^ D1 ^ D0`|
|4|0100|`~D3 ^ D2 ^ ~D1 ^ ~D0`|
|5|0101|`~D3 ^ D2 ^ ~D1 ^ D0`|
|6|0110|`~D3 ^ D2 ^ D1 ^ ~D0`|
|7|0111|`~D3 ^ D2 ^ D1 ^ D0`|
|8|1000|`D3 ^ ~D2 ^ ~D1 ^ ~D0`|

```c
C = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ ~D2 ^ ~D1 ^ D0)
  v (~D3 ^ ~D2 ^ D1 ^ D0)
  v (~D3 ^ D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ D2 ^ ~D1 ^ D0)
  v (~D3 ^ D2 ^ D1 ^ ~D0)
  v (~D3 ^ D2 ^ D1 ^ D0)
  v (D3 ^ ~D2 ^ ~D1 ^ ~D0)
```

### *d*

O segmento `d` fica aceso nos casos obtidos na tabela: `0, 5, 6 e 8`.

| Caso | Binário | Mintermo |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|5|0101|`~D3 ^ D2 ^ ~D1 ^ D0`|
|6|0110|`~D3 ^ D2 ^ D1 ^ ~D0`|
|8|1000|`D3 ^ ~D2 ^ ~D1 ^ ~D0`|

```c
D = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ D2 ^ ~D1 ^ D0)
  v (~D3 ^ D2 ^ D1 ^ ~D0)
  v (D3 ^ ~D2 ^ ~D1 ^ ~D0)
```

### *e*

O segmento `e` fica aceso nos casos obtidos na tabela: `0, 2, 6 e 8`.

| Caso | Binário | Mintermo |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|2|0010|`~D3 ^ ~D2 ^ D1 ^ ~D0`|
|6|0110|`~D3 ^ D2 ^ D1 ^ ~D0`|
|8|1000|`D3 ^ ~D2 ^ ~D1 ^ ~D0`|

```c
E = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ ~D2 ^ D1 ^ ~D0)
  v (~D3 ^ D2 ^ D1 ^ ~D0)
  v (D3 ^ ~D2 ^ ~D1 ^ ~D0)
```

> Para não confundir o segmento `e` com o sinal de erro `E`, nesta seção foi usado `E_seg` apenas como identificação da expressão do segmento `e`.

### *f*

O segmento `f` fica aceso nos casos obtidos na tabela: `0, 4, 5, 6 e 8`.

| Caso | Binário | Mintermo |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|4|0100|`~D3 ^ D2 ^ ~D1 ^ ~D0`|
|5|0101|`~D3 ^ D2 ^ ~D1 ^ D0`|
|6|0110|`~D3 ^ D2 ^ D1 ^ ~D0`|
|8|1000|`D3 ^ ~D2 ^ ~D1 ^ ~D0`|

```c
F = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ D2 ^ ~D1 ^ ~D0)
  v (~D3 ^ D2 ^ ~D1 ^ D0)
  v (~D3 ^ D2 ^ D1 ^ ~D0)
  v (D3 ^ ~D2 ^ ~D1 ^ ~D0)
```

### *g*

A dedução de `g` é feita a partir dos casos em que o segmento está apagado, trabalhando primeiro com o complemento `~G` e, ao final, aplicando a Lei de De Morgan para obter `G`.

Os casos considerados foram `0, 1, 7, 9, 10, 11, 12, 13, 14 e 15`.

| Caso | Binário | Mintermo de `~G` |
|---|---|---|
|0|0000|`~D3 ^ ~D2 ^ ~D1 ^ ~D0`|
|1|0001|`~D3 ^ ~D2 ^ ~D1 ^ D0`|
|7|0111|`~D3 ^ D2 ^ D1 ^ D0`|
|9|1001|`D3 ^ ~D2 ^ ~D1 ^ D0`|
|10|1010|`D3 ^ ~D2 ^ D1 ^ ~D0`|
|11|1011|`D3 ^ ~D2 ^ D1 ^ D0`|
|12|1100|`D3 ^ D2 ^ ~D1 ^ ~D0`|
|13|1101|`D3 ^ D2 ^ ~D1 ^ D0`|
|14|1110|`D3 ^ D2 ^ D1 ^ ~D0`|
|15|1111|`D3 ^ D2 ^ D1 ^ D0`|

Assim:

```c
~G = (~D3 ^ ~D2 ^ ~D1 ^ ~D0)
   v (~D3 ^ ~D2 ^ ~D1 ^ D0)
   v (~D3 ^ D2 ^ D1 ^ D0)
   v (D3 ^ ~D2 ^ ~D1 ^ D0)
   v (D3 ^ ~D2 ^ D1 ^ ~D0)
   v (D3 ^ ~D2 ^ D1 ^ D0)
   v (D3 ^ D2 ^ ~D1 ^ ~D0)
   v (D3 ^ D2 ^ ~D1 ^ D0)
   v (D3 ^ D2 ^ D1 ^ ~D0)
   v (D3 ^ D2 ^ D1 ^ D0)
```

#### Simplificação de `~G`

**1. Mintermos 0 e 1:**

```c
(~D3 ^ ~D2 ^ ~D1 ^ ~D0) v (~D3 ^ ~D2 ^ ~D1 ^ D0)

= ~D3 ^ ~D2 ^ ~D1 ^ (~D0 v D0)

= ~D3 ^ ~D2 ^ ~D1
```

Foi usada a **Lei da Complementação**, `~D0 v D0 = 1`, seguida da **Lei da Identidade**, `X ^ 1 = X`.

**2. Mintermos 1 e 9:**

```c
(~D3 ^ ~D2 ^ ~D1 ^ D0) v (D3 ^ ~D2 ^ ~D1 ^ D0)

= ~D2 ^ ~D1 ^ D0 ^ (~D3 v D3)

= ~D2 ^ ~D1 ^ D0
```

Assim, este agrupamento acrescenta o termo:

```c
~D2 ^ ~D1 ^ D0
```

**3. Mintermos 10 e 11:**

```c
(D3 ^ ~D2 ^ D1 ^ ~D0) v (D3 ^ ~D2 ^ D1 ^ D0)

= D3 ^ ~D2 ^ D1 ^ (~D0 v D0)

= D3 ^ ~D2 ^ D1
```

**4. Mintermos 12 e 13:**

```c
(D3 ^ D2 ^ ~D1 ^ ~D0) v (D3 ^ D2 ^ ~D1 ^ D0)

= D3 ^ D2 ^ ~D1 ^ (~D0 v D0)

= D3 ^ D2 ^ ~D1
```

**5. Mintermos 14 e 15:**

```c
(D3 ^ D2 ^ D1 ^ ~D0) v (D3 ^ D2 ^ D1 ^ D0)

= D3 ^ D2 ^ D1 ^ (~D0 v D0)

= D3 ^ D2 ^ D1
```

**6. Simplificando os termos com `D3`:**

```c
(D3 ^ ~D2 ^ D1)
 v (D3 ^ D2 ^ ~D1)
 v (D3 ^ D2 ^ D1)

= D3 ^ [(~D2 ^ D1) v (D2 ^ ~D1) v (D2 ^ D1)]

= D3 ^ [(~D2 ^ D1) v D2]

= D3 ^ (D2 v D1)

= (D3 ^ D2) v (D3 ^ D1)
```

**7. Incluindo o mintermo 7:**

```c
(D3 ^ D1) v (~D3 ^ D2 ^ D1 ^ D0)

= D1 ^ [D3 v (~D3 ^ D2 ^ D0)]

= D1 ^ (D3 v D2 ^ D0)

= (D3 ^ D1) v (D1 ^ D2 ^ D0)
```

**Resultado obtido para `~G`:**

```c
~G = (~D3 ^ ~D2 ^ ~D1)
   v (~D2 ^ ~D1 ^ D0)
   v (D3 ^ D2)
   v (D3 ^ D1)
   v (D1 ^ D2 ^ D0)
```

### Obtendo `G` pela Lei de De Morgan

Agora invertemos toda a expressão:

```c
G = ~(~G)
```

Aplicando a **Lei de De Morgan**:

```c
G = ~(~D3 ^ ~D2 ^ ~D1)
  ^ ~(~D2 ^ ~D1 ^ D0)
  ^ ~(D3 ^ D2)
  ^ ~(D3 ^ D1)
  ^ ~(D1 ^ D2 ^ D0)
```

Aplicando novamente De Morgan em cada termo:

```c
G = (D3 v D2 v D1)
  ^ (D2 v D1 v ~D0)
  ^ (~D3 v ~D2)
  ^ (~D3 v ~D1)
  ^ (~D1 v ~D2 v ~D0)
```

**RESULTADO FINAL:**

```c
G = (D3 v D2 v D1)
  ^ (D2 v D1 v ~D0)
  ^ (~D3 v ~D2)
  ^ (~D3 v ~D1)
  ^ (~D1 v ~D2 v ~D0)
```

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
## Observações sobre o projeto

##### Sinais

- MemRead [bool]: ativo em HIGH e inativo em LOW, inicialmente HIGH isso porque temos que ler a instrução da memória independete da unidade de controle.

- InstRegWrite [bool]: ativo em HIGH inativo em LOW. Inicialmente HIGH, pelo mesmo motivo de MemRead.

- MemWrite [bool]: ativo em HIGH, inativo em LOW, para prevenir escritas de lixo. Inicialmente LOW.

- IorD [seletor]: inicialmente 0 para que escolha o PC como input de addr na mem.

- RegWrite [bool]: ativo em HIGH, inativo em LOW. Inicialmente LOW.

- AluSrcA [seletor]: inicialmente 0 para que escolha o PC.

- AluSrcB [seletor]: inicialmente 01 para que escolha a constante 4.

- PCSrc [seletor]: inicialmente 00 para escolher o resultado da ALU.

- PCWrite [bool]: ativo em HIGH, inativo em LOW. Inicialmente HIGH para que permita a escrita do PC.

<!-- Operação de add
IorD 0
MemRead LOW
InstRegWrite LOW
AluSrcA 0
AluSrcB 01
AluCtrl 100000  <!-- Add ->
PCSrc 00
PCWrite LOW  -->

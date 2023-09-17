# destroyAws
O script destroy.sh foi criado após uma invasão de conta AWS onde vários recursos foram criados pelo invasor em várias regiões diferentes.
Para agilizar o processo de destruição e cortar os custos que seriam gerados, resolvi automatizar o processo.
Com certeza dá pra melhorar bastante, mas já quebrou um galho.

Antes de executar, coloque no arquivo regions.txt as regiões que deseja buscar e apagar os recursos.
As regiões devem ser adicionadas uma abaixo da outra.
Por exemplo:

us-east-1

sa-east-1

Para executar o script, primeiro conseda permissão de execução:
chmod +x destroy.sh

Depois execute:
./destroy.sh

Um menu com opções de recursos irão abrir. Escolha uma e o script irá buscar o recursos existentes e apagar automaticamente.

É necessário que o aws cli esteja com o profile da conta configurado.

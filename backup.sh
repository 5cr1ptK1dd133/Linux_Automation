#!/bin/bash

FILES='/root/files.list'
DATA=$(date +%d-%m-%Y)

echo -n 'Realizando dump das bases de dados...'
mysqldump -uroot -password --all-databases > /dados/dump.sql 2>/dev/null
[ $? -eq 0 ] && echo "Arquivo backup_$DATA criado com sucesso" | echo 'ERRO'

echo -n 'Compactando pacote .tar.gz...'
tar -czf backup_$DATA.tar.gz -T files.list > /dev/null 2>&1
[ $? -eq 0 ] && echo "Arquivo backup_$DATA.tar.gz criado com sucesso" | echo 'ERRO'

echo -n 'Enviando para o servidor remoto ...'
scp backup_$DATA.tar.gz root@192.168.56.201:/bkps_recebidos >/dev/null 2>&1
[ $? -eq 0 ] && echo "Arquivo backup_$DATA.tar.gz enviado com sucesso" || echo 'ERRO'

echo -n 'Checando a integridade do arquivo remoto ...'
HASH_LOCAL=$(md5sum backup_$DATA.tar.gz | awk '{print $1}')
HASH_REMOTO=$(ssh  root@192.168.56.201 md5sum /bkps_recebidos/backup_$DATA.tar.gz | awk '{print $1}')

[ $HASH_LOCAL = $HASH_REMOTO ] && echo 'Arquivos identicos' || echo 'ERRO'

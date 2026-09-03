#!/bin/bash

# CONFIGURAÇÃO DOS REQUISITOS MÍNIMOS
RAM_MINIMA_MB=17562
ESPACO_MINIMO_GB=50

FALHA=0

echo "=========================================================="
echo " INICIANDO AUDITORIA DE PRÉ-REQUISITOS DE HARDWARE"
echo "=========================================================="

# 1. Validação de Memória RAM
RAM_TOTAL_MB=$(awk '/^MemTotal:/ {printf "%.0f", $2 / 1024}' /proc/meminfo)

if [[ "$RAM_TOTAL_MB" =~ ^[0-9]+$ ]]; then

    echo "-> Memória RAM Total Detectada: ${RAM_TOTAL_MB} MB"

    if [ "$RAM_TOTAL_MB" -lt "$RAM_MINIMA_MB" ]; then
        echo " [REPROVADO] Memória RAM insuficiente."
        echo "             Mínimo exigido: ${RAM_MINIMA_MB} MB"
        FALHA=1
    else
        echo " [APROVADO] Memória RAM atende aos requisitos."
    fi

else

    echo " [ERRO] Não foi possível identificar a memória RAM."
    FALHA=1

fi


# 2. Validação de Espaço em Disco (Partição raiz /)
DISCO_DISP_GB=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')

if [[ "$DISCO_DISP_GB" =~ ^[0-9]+$ ]]; then

    echo "-> Espaço Disponível em Disco (/): ${DISCO_DISP_GB} GB"

    if [ "$DISCO_DISP_GB" -lt "$ESPACO_MINIMO_GB" ]; then
        echo " [REPROVADO] Espaço em disco insuficiente."
        echo "             Mínimo exigido: ${ESPACO_MINIMO_GB} GB"
        FALHA=1
    else
        echo " [APROVADO] Espaço em disco atende aos requisitos."
    fi

else

    echo " [ERRO] Não foi possível identificar o espaço em disco."
    FALHA=1

fi


echo "=========================================================="

if [ "$FALHA" -eq 1 ]; then
    echo " STATUS FINAL: AMBIENTE REPROVADO PARA INSTALAÇÃO."
    exit 1
else
    echo " STATUS FINAL: AMBIENTE TOTALMENTE APROVADO!"
    exit 0
fi

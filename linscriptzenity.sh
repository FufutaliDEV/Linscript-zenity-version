#!/bin/bash

# --- 1. FUNÇÃO DE VERIFICAÇÃO E INSTALAÇÃO DE ZENITY ---
verificar_e_instalar_zenity() {
    if ! command -v zenity &> /dev/null
    then
        echo "Zenity não encontrado. Tentando instalar..."
        echo "Instalando Zenity. Por favor, aguarde e insira sua senha se for solicitada."
        
        sudo apt update > /dev/null 2>&1
        sudo apt install zenity -y

        if [ $? -ne 0 ]; then
            echo "ERRO: Não foi possível instalar o Zenity. Verifique sua conexão e se o dpkg está liberado."
            exit 1
        fi
        
        echo "Zenity instalado com sucesso."
    fi
}

# --- 2. FUNÇÕES DE AÇÃO COM SUGESTÕES DE PACOTES ---

# Função 1: Instalar Aplicativos (Busca no 'apt search' se falhar)
instalar_apps() {
    PACOTE_ENTRADA=$(zenity --entry \
        --title="Instalar Novo Aplicativo" \
        --text="Digite o NOME do programa (Ex: gimp, vlc, firefox-esr):")

    if [ -n "$PACOTE_ENTRADA" ]; then
        
        # 1. Tenta instalar
        zenity --info --title="Aguarde" --text="Tentando instalar: $PACOTE_ENTRADA. Pode ser necessário digitar a senha do Linux no terminal." &
        PID_ZENITY=$!
        
        sudo apt install "$PACOTE_ENTRADA" -y > /tmp/log_instalacao.txt 2>&1
        
        kill $PID_ZENITY 2> /dev/null

        # 2. Verifica o resultado
        if [ $? -eq 0 ]; then
            zenity --info --title="✅ Sucesso!" --text="O aplicativo '$PACOTE_ENTRADA' foi instalado."
        else
            # 3. Se falhar, faz a busca por sugestões no terminal
            zenity --error --title="❌ Falha na Instalação" --text="Pacote '$PACOTE_ENTRADA' não encontrado ou instalação falhou. Verifique o terminal para sugestões de nomes e detalhes do erro."
            
            echo "--------------------------------------------------------"
            echo "❌ FALHA NA INSTALAÇÃO: '$PACOTE_ENTRADA'"
            echo "Tentando encontrar sugestões com o termo:"
            echo "--------------------------------------------------------"
            
            # Faz a busca e formata a saída como uma tabela no terminal
            # Limitamos a 20 linhas para não inundar o terminal
            apt search "$PACOTE_ENTRADA" | head -n 20 
            
            echo "--------------------------------------------------------"
            echo "Copie o nome exato do pacote e tente novamente."
            echo "--------------------------------------------------------"
        fi
    fi
}

# Função 2: Desinstalar Aplicativos (Busca no 'dpkg -l' se o termo for curto)
desinstalar_apps() {
    PACOTE_ENTRADA=$(zenity --entry \
        --title="Desinstalar Aplicativo" \
        --text="Digite o NOME do pacote que deseja REMOVER (Ex: gimp, vlc): \n\nSe tiver dúvidas sobre o nome, digite um termo curto para ver sugestões no terminal.")

    if [ -n "$PACOTE_ENTRADA" ]; then
        
        # 1. Se a entrada for muito curta (1 ou 2 letras), assume que é uma busca por sugestão
        if [ ${#PACOTE_ENTRADA} -lt 3 ]; then
            zenity --info --title="Sugestão de Busca" --text="Termo curto digitado. Verifique o terminal para ver pacotes instalados que contêm '$PACOTE_ENTRADA'."
            
            echo "--------------------------------------------------------"
            echo "🔎 PACOTES INSTALADOS que contêm '$PACOTE_ENTRADA':"
            echo "--------------------------------------------------------"
            # Lista os pacotes instalados que contêm o termo de busca, formatado em colunas
            dpkg-query -W -f='${Package}\t${Description}\n' | grep -i "$PACOTE_ENTRADA" | column -t
            echo "--------------------------------------------------------"
            echo "Copie o nome exato do pacote e tente novamente."
            echo "--------------------------------------------------------"
            return
        fi

        # 2. Pede confirmação para remover
        zenity --question --title="Confirmação de Remoção" --text="Tem certeza que deseja remover o pacote '$PACOTE_ENTRADA'?\nIsso é irreversível."
        if [ $? -eq 0 ]; then
            
            zenity --info --title="Aguarde" --text="Removendo: $PACOTE_ENTRADA. Pode ser necessário digitar a senha do Linux no terminal." &
            PID_ZENITY=$!
            
            # Executa a desinstalação
            sudo apt purge "$PACOTE_ENTRADA" -y > /tmp/log_desinstalacao.txt 2>&1
            sudo apt autoremove -y >> /tmp/log_desinstalacao.txt 2>&1

            kill $PID_ZENITY 2> /dev/null

            # 3. Verifica o resultado
            if [ $? -eq 0 ]; then
                zenity --info --title="✅ Sucesso!" --text="O aplicativo '$PACOTE_ENTRADA' foi removido com sucesso."
            else
                zenity --error --title="❌ Falha na Remoção" --text="O pacote '$PACOTE_ENTRADA' não foi encontrado ou a remoção falhou. Verifique o terminal para detalhes do erro."
            fi
        fi
    fi
}

# Função 3: Atualizar o Sistema (sem mudanças)
atualizar_sistema() {
    zenity --info --title="Atualização" --text="Atualizando o sistema Linux. Por favor, aguarde..." &
    PID_ZENITY=$!
    
    sudo apt update && sudo apt upgrade -y > /tmp/log_atualizacao.txt 2>&1
    
    kill $PID_ZENITY 2> /dev/null

    if [ $? -eq 0 ]; then
        zenity --info --title="✅ Sucesso!" --text="Sistema atualizado com sucesso!"
    else
        zenity --text-info --title="❌ Erro na Atualização" --filename=/tmp/log_atualizacao.txt --width=500 --height=300
    fi
}


# --- 3. MENU PRINCIPAL ---
verificar_e_instalar_zenity

while true; do
    SELECAO=$(zenity --list \
        --title="Ferramentas de Manutenção Chrome OS Flex" \
        --text="Selecione a tarefa que deseja executar:" \
        --column="ID" \
        --column="Ação" \
        "1" "Instalar Aplicativo (Com Busca)" \
        "2" "Desinstalar Aplicativo (Com Busca)" \
        "3" "Atualizar o Sistema" \
        "4" "Sair" \
        --height=300 --width=450)

    if [ $? -ne 0 ] || [ "$SELECAO" = "4" ]; then
        break
    fi

    case "$SELECAO" in
        1) instalar_apps ;;
        2) desinstalar_apps ;;
        3) atualizar_sistema ;;
        *) zenity --error --text="Opção inválida: $SELECAO" ;;
    esac
done

exit 0
#feito por fufutali ;\

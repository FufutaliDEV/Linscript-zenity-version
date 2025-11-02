# Linscript-zenity-version
Uma interface gráfica simples e eficiente para gerenciar pacotes e executar tarefas essenciais no Linux. Desenvolvido para usuários iniciantes que preferem não digitar comandos complexos no terminal.
✨ O que este projeto faz?
Este projeto oferece uma interface Zenity (baseada em caixas de diálogo) para automatizar as seguintes tarefas de manutenção do sistema Linux:

Instalação de Pacotes: Instala softwares comuns rapidamente (como editores de texto ou ferramentas de desenvolvimento).

Remoção de Pacotes: Desinstala programas de forma limpa.

Atualização do Sistema: Executa sudo apt update e sudo apt upgrade em uma única etapa, mantendo o sistema seguro e atualizado.

Limpeza do Sistema: Remove pacotes órfãos e arquivos de cache (autoremove e clean) para liberar espaço em disco.

🚀 Instalação Rápida no Chrome OS Flex
A instalação é feita através de um único script, que baixa a versão mais recente do Linscript, instala as dependências necessárias e cria um atalho de aplicativo no seu menu do Chrome OS.

Passo 1: Baixe o Instalador
Baixe o arquivo Linscript-Instalador.sh para sua pasta Arquivos Linux.

Passo 2: Execute no Terminal
Abra o Terminal Linux (>_) e execute os seguintes comandos:

Bash

# Navegue até a pasta de download (se necessário)
cd ~/Downloads 

# Dê permissão de execução ao script
chmod +x Linscript-zenity.sh

# Execute o instalador
./Linscript-zenity.sh
O script irá instalar o zenity (se necessário), baixar o Linscript, criar o ícone de atalho no seu menu e abrir a interface Zenity automaticamente.

🖼️ Como Funciona?
O Linscript utiliza o Zenity para transformar comandos de terminal em caixas de diálogo intuitivas, permitindo que você escolha ações e insira informações sem precisar memorizar comandos.


⚙️ Detalhes Técnicos
Tecnologia: Shell Script (Bash) e Zenity.

Compatibilidade: Projetado e testado para distros que usam os pacotes DNF,PACMAN e APT.

Mecanismo de Atualização: O instalador sempre baixa a versão mais recente do script deste Gist/Repositório, garantindo que você esteja sempre usando a última versão.

📝 Contribuições
Sinta-se à vontade para sugerir melhorias, correções ou novas ferramentas para serem adicionadas ao menu Zenity!

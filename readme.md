## 1. Visão Geral do Produto

### 1.1. Definição do Sistema
O **Organizador de Pagamentos** é uma solução de software desenvolvida para gerenciar, gerar e validar transações financeiras de forma automatizada. O sistema foca na criação de cobranças dinâmicas para garantir a integridade do fluxo de recebíveis de um negócio.

### 1.2. Declaração do Problema
Atualmente, a aceitação de pagamentos via PIX em processos manuais apresenta uma vulnerabilidade crítica: a **fraude por alteração de comprovantes**. O uso de editores de imagem para falsificar valores, datas ou o status de "concluído" em PDFs e prints de tela gera prejuízos financeiros diretos e sobrecarrega a equipe de conferência, que precisa validar manualmente cada entrada no extrato bancário.

### 1.3. Proposta de Solução
O sistema mitiga riscos de fraude ao substituir o uso de chaves PIX estáticas pela geração de **QR Codes Dinâmicos** e códigos **Pix Copia e Cola** exclusivos para cada transação. 

**Os principais pilares da solução são:**
* **Autenticidade:** Cada cobrança é vinculada a um ID de transação único no banco de dados.
* **Validação Sistêmica:** A confirmação do pagamento não depende da análise visual de um comprovante enviado pelo cliente, mas sim do status retornado pela instituição financeira.
* **Segurança:** Redução drástica de golpes e erros humanos no processo de conciliação de pagamentos.

2. Arquitetura de Interação e Fluxos de Processo

### 2.1. Atores do Sistema
Para compreender o fluxo operacional, definimos três entidades principais envolvidas no processo de pagamento:

* **Cliente Final:** O consumidor que está adquirindo o produto ou serviço e realizará o pagamento via PIX.
* **Empresa (Vendedor/Atendente):** O usuário principal do sistema. É quem negocia com o cliente final e interage com o chatbot para solicitar a geração da cobrança.
* **Chatbot (Organizador de Pagamentos):** A interface automatizada no WhatsApp, responsável por processar o valor recebido, comunicar-se com a API bancária (ou gateway de pagamento) para gerar a transação e devolver os dados de cobrança.

### 2.2. Fluxo Principal: Geração e Repasse de Cobrança

O processo de venda e geração do pagamento segue uma jornada linear, ocorrendo majoritariamente no ambiente do WhatsApp:

1. **Fechamento e Acordo:** A Empresa (Vendedor) e o Cliente Final concluem a negociação. O Cliente solicita o valor total ou a Empresa informa o valor final (ex: R$ 500,00).
2. **Acionamento do Sistema:** A Empresa abre a conversa com o Chatbot do Organizador de Pagamentos no WhatsApp e envia o valor da compra (junto com possíveis identificadores, se necessário).
3. **Geração da Cobrança:** O Chatbot recebe a mensagem, interpreta o valor e se comunica com o gateway de pagamento. O sistema gera uma cobrança PIX com um *Transaction ID* único.
4. **Retorno da Cobrança:** O Chatbot responde à Empresa enviando a imagem do QR Code dinâmico e o respectivo código "Pix Copia e Cola".
5. **Repasse ao Cliente:** A Empresa encaminha a mensagem recebida do Chatbot diretamente para o Cliente Final.
6. **Pagamento (Cliente):** O Cliente Final realiza a leitura do QR Code ou utiliza o código "Copia e Cola" no aplicativo do seu banco para efetuar o pagamento.
7. **Validação Sistêmica (Aguardando Confirmação):** O gateway de pagamento processa a transação e notifica o backend do sistema de que o PIX foi liquidado com sucesso.
8. **Notificação de Sucesso:** O Chatbot envia uma nova mensagem para a Empresa confirmando automaticamente o recebimento do valor exato (ex: "✅ Pagamento de R$ 500,00 confirmado!"), liberando a entrega da mercadoria sem necessidade de verificação de comprovantes manuais.

3. Arquitetura de Integração e Validação

### 3.1. Comunicação Assíncrona via Webhooks
A validação de pagamentos do sistema foi projetada para ser ágil, segura e executada em tempo real. Para isso, o sistema não realiza consultas periódicas (*polling*) para verificar o status de uma cobrança. Em vez disso, a comunicação com o provedor financeiro (Gateway de Pagamento / Banco) é feita de forma assíncrona utilizando **Webhooks**.

### 3.2. Fluxo Técnico de Confirmação (Webhook)
O processo de validação em background ocorre nas seguintes etapas:

1. **Liquidação Financeira:** O cliente final conclui o pagamento do PIX em seu aplicativo bancário.
2. **Disparo do Evento:** O Gateway de Pagamento processa o recebimento e dispara instantaneamente uma requisição HTTP `POST` para o *endpoint* de Webhook exposto pelo nosso sistema.
3. **Validação de Segurança:** O *backend* do Organizador de Pagamentos recebe a requisição (*payload*) e valida a autenticidade da origem (utilizando *tokens* de autorização, assinaturas criptográficas ou IPs permitidos).
4. **Atualização de Estado:** O sistema extrai o identificador único da transação (`Transaction ID`) do *payload* e atualiza o status da cobrança no banco de dados de `Pendente` para `Pago`.
5. **Notificação Ativa:** O *backend* aciona imediatamente o módulo do Chatbot (API do WhatsApp) para enviar a mensagem de sucesso à Empresa, fechando o ciclo de venda com segurança.


4. Interface Web - Portal do Cliente

### 4.1. Landing Page (Portal Público)
A porta de entrada do sistema, projetada para converter novos usuários e fornecer acesso aos clientes atuais.
* **Boas-vindas:** Apresentação da proposta de valor (segurança contra golpes de PIX).
* **Autenticação:** Sistema de Login/Cadastro seguro para as empresas usuárias.
* **Documentação:** Espaço dedicado para instruções de como configurar o chatbot no WhatsApp da empresa.

### 4.2. Dashboard de Gestão (Área Logada)
Uma vez autenticada, a Empresa tem acesso a um painel administrativo para controle total das operações:

* **Visão Geral (Cards):** * Total recebido (dia/mês/semana).
    * Quantidade de transações pendentes vs. confirmadas.
    * Ticket médio das vendas.
* **Gestão de Transações:** Tabela detalhada com histórico de cobranças geradas, status em tempo real (Pendente/Pago/Expirado) e ID da transação vinculado ao banco de dados.
* **Configurações de Integração:** Campo para cadastrar o Webhook do banco e gerenciar a chave de API que conecta o sistema ao WhatsApp.
* **Relatórios:** Gráficos de desempenho de vendas, ideais para a conciliação financeira ao final do dia.
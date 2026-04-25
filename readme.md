# 🚀 Me Paga
**A solução definitiva para automatizar e blindar sua esteira de recebimentos PIX.**

---

## 🎯 Pitch de Vendas (Visão de Negócios)

### ⚠️ 1. O Problema
Atualmente, negócios digitais, infoprodutores e sistemas de delivery enfrentam dois gargalos letais ao aceitar PIX:
1. **Fraudes:** O "golpe do comprovante falso" via edição de imagens (PDFs/Prints) causa um prejuízo silencioso, mas massivo.
2. **Lentidão Operacional:** Ter um ser humano validando extrato bancário para cada venda não é um modelo escalável. Isso atrasa a entrega do produto e frustra o cliente.

### 💡 2. A Solução
O **Me Paga** elimina o gargalo e a fraude de uma vez só através de:
* **Geração Dinâmica:** Substituímos as antigas chaves estáticas por **QR Codes Dinâmicos** e chaves **Pix Copia e Cola** gerados de forma única para cada transação e cliente.
* **Validação Criptográfica (Webhook):** Não precisamos ver comprovantes. Quando o PIX cai na conta, recebemos o *callback* direto da instituição financeira e avisamos seu sistema instantaneamente.
* **Liberação Imediata:** A conversão é confirmada em milissegundos, disparando a entrega do produto com zero erro humano.

### 📈 3. Modelo de Negócios (SaaS B2B)
Nosso modelo garante alta previsibilidade de receita e margens de lucro saudáveis e escaláveis:

| Plano | Limite Transacional | Preço Mensal | Custo Variável | Margem Bruta Aprox. |
| :--- | :--- | :--- | :--- | :--- |
| **Essencial** | até 100/mês | R$ 297,00 | R$ 150,00 | **49%** |
| **Profissional** | até 500/mês | R$ 1.497,00 | R$ 750,00 | **50%** |
| **Scale** | até 1.000/mês | R$ 2.997,00 | R$ 1.500,00 | **50%** |
| **Enterprise** | até 2.500/mês | R$ 4.997,00 | R$ 3.750,00 | **25%** |

### 💎 4. Nossos Diferenciais Competitivos
* **Developer-First:** Nossa API RESTful e ambiente de Webhooks foram criados para plugar em menos de 10 minutos em arquiteturas como Typebot, Chatwoot, n8n ou ERPs próprios.
* **Anti-Fraude Nativo:** Como não aceitamos imagens (comprovantes visuais), a taxa de fraude financeira sistêmica cai imediatamente para 0%.
* **Experiência Premium:** Dashboard de gestão completo em HTML5/CSS3 nativo com transições fluidas e sistema global de *Dark Mode* que preserva a experiência do usuário administrador.

---

## 💻 Documentação Técnica (Setup para Jurados/Avaliação)

### Stack Tecnológica (MVP Hackathon)
O projeto foi concebido para alta performance e demonstração limpa:
* **Frontend:** HTML5, CSS3, JavaScript (ES6+ Vanilla).
* **Gráficos:** Integração com Chart.js para analytics.
* **Persistência de Dados (Mock Backend):** `localStorage` nativo do navegador para armazenamento de estado das transações, permitindo o uso da aplicação sem necessidade de configurar bancos de dados complexos ou rodar servidores (100% Client-Side para a etapa de validação).

### Como Rodar o Projeto Localmente
Este MVP não exige instalação de pacotes complexos (Node/NPM) ou containers Docker.

1. Faça o clone do repositório:
   ```bash
   git clone https://github.com/engphilipe/Me-Paga.git
   ```
2. Abra a pasta do projeto no **VS Code**.
3. Utilize a extensão **Live Server** e inicie o projeto pelo arquivo `index.html`.
4. **Pronto!** O sistema estará funcionando perfeitamente em `localhost`. 
   *(Nota: Toda a navegação, geração de PIX e relatórios funcionarão persistindo os dados diretamente no cache do seu navegador).*

### Fluxo de Demonstração (Dica de Apresentação)
Para a demonstração do Hackathon, sugerimos o seguinte fluxo ao vivo:
1. Abra a **Landing Page (`index.html`)**;
2. Navegue pelos benefícios e exiba a Tabela de Preços (explique a margem bruta no pitch);
3. Entre no sistema clicando em **Login** (basta preencher e avançar);
4. No **Dashboard**, clique em "+ Nova Cobrança", insira valores fictícios e mostre o **Pix Copia e Cola**;
5. Mostre o botão flutuante de alternância **Light/Dark Mode** funcionando de forma fluida por todo o sistema.
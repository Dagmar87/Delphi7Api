# 📄 Desafio Técnico: Desenvolvimento de API com Delphi 7

## 1. Visão Geral
O objetivo deste teste é avaliar habilidades em lógica de programação, arquitetura de software e a capacidade de expor serviços HTTP usando Delphi 7. Deve ser construída uma API local capaz de receber requisições e retornar dados no formato JSON.

---

## 2. Requisitos Técnicos
- **Linguagem:** Delphi 7
- **Formato de dados:** JSON
- **Integração local:** A API deve ser consumível localmente a partir de scripts no XAMPP (PHP/Apache). As rotas também devem ser testáveis via Insomnia, navegador ou curl.

---

## 3. Escopo do Projeto
Desenvolver um serviço backend executável que gerencie uma entidade simples (ex.: Produtos) com as rotas obrigatórias abaixo:

- `GET /api/status` — Retorna o status da API
  - Exemplo de resposta: `{"status":"online"}`

- `GET /api/produtos` — Retorna lista de produtos em JSON

- `GET /api/produtos/{id}` — Retorna detalhes do produto pelo `id`

- `POST /api/produtos` — Recebe JSON no corpo para simular criação de novo registro

---

## 4. Entrega do Projeto
- Prazo: 7 dias
- Código-fonte (projeto Delphi)
- Executável da API
- Pasta `xampp/` configurada para consumo local
- Collection (Postman/Insomnia) com as rotas de consumo — ver `collection/Delphi_API.json`

---

## 5. Instruções de Instalação e Execução
Siga estes passos para executar a API localmente:

1. Instale o Delphi 7 (compilador/IDE) e abra o projeto `Delphi7Api.dpr`.
2. Compile o projeto para gerar o executável (ex.: `Delphi7Api.exe`).
3. Instale XAMPP e verifique que o Apache/PHP estão funcionando.
4. Copie o executável e arquivos necessários para uma pasta acessível pelo Apache (ex.: `C:/xampp/htdocs/delphi_api/`) ou mantenha a API rodando separadamente e faça chamadas para `http://localhost:<porta>/...` conforme sua configuração.
5. Inicie a API (execute o `.exe`) e verifique `GET /api/status` no browser ou via curl.

Exemplo básico com curl (Windows PowerShell):

```powershell
curl http://localhost:8080/api/status
```

Obs: Ajuste a porta conforme a configuração do seu servidor/serviço Delphi.

---

## 6. Pré-requisitos (versões recomendadas)
- Windows (ambiente de desenvolvimento)
- Delphi 7
- XAMPP (Apache + PHP) — recomendado XAMPP com PHP 7.2+ (qualquer versão estável que suporte suas ferramentas)
- Banco (opcional para persistência): PostgreSQL 9.6+ ou MySQL 5.7+ — a API pode inicialmente simular dados em memória se necessário.

---

## 7. Configuração do Banco de Dados (exemplo SQL)
Se optar por usar um banco relacional, exemplo de tabela `produtos`:

```sql
CREATE TABLE produtos (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  preco NUMERIC(10,2),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO produtos (nome, descricao, preco) VALUES
('Produto A', 'Descrição A', 10.50),
('Produto B', 'Descrição B', 25.00);
```

Configuração na API: atualize a string de conexão conforme seu SGBD (Postgres/MySQL). Se não houver banco, mantenha uma lista em memória para os endpoints.

---

## 8. Exemplos de Requests e Responses

1) GET /api/status

Request:

```http
GET /api/status HTTP/1.1
Host: localhost:8080
```

Response:

```json
{ "status": "online" }
```

2) GET /api/produtos

Request:

```http
GET /api/produtos HTTP/1.1
Host: localhost:8080
```

Response (exemplo):

```json
[
  { "id": 1, "nome": "Produto A", "descricao": "Descrição A", "preco": 10.5 },
  { "id": 2, "nome": "Produto B", "descricao": "Descrição B", "preco": 25.0 }
]
```

3) GET /api/produtos/1

Response (exemplo):

```json
{ "id": 1, "nome": "Produto A", "descricao": "Descrição A", "preco": 10.5 }
```

4) POST /api/produtos

Request (JSON body):

```json
{
  "nome": "Produto C",
  "descricao": "Descrição C",
  "preco": 15.75
}
```

Exemplo curl para envio:

```bash
curl -X POST http://localhost:8080/api/produtos \
  -H "Content-Type: application/json" \
  -d '{"nome":"Produto C","descricao":"Descrição C","preco":15.75}'
```

Exemplo de resposta (simulação de criação):

```json
{ "success": true, "id": 3 }
```

---

## 9. Como testar a aplicação
- Via navegador: acesse `http://localhost:8080/api/status` ou `http://localhost:8080/api/produtos`.
- Via Insomnia / Postman: importe `collection/Delphi_API.json` ou crie as rotas manualmente.
- Via curl (exemplos acima).
- Via PHP no XAMPP: crie um script simples em `htdocs` que chama `file_get_contents('http://localhost:8080/api/produtos')` ou use `curl` no PHP.

Exemplo rápido em PHP (arquivo `xampp/teste.php`):

```php
<?php
echo file_get_contents('http://localhost:8080/api/produtos');
```

---

## 10. Estrutura do Repositório (resumida)
- `Delphi7Api.dpr` - projeto principal Delphi
- `Main.pas`, `UProdutoModel.pas` - unidades principais
- `collection/Delphi_API.json` - collection para Insomnia/Postman
- `xampp/` - exemplos de scripts para consumir a API localmente

---

## 11. Próximos Passos / Observações
- Ajuste strings de conexão e porta conforme seu ambiente local.
- Se preferir, a API pode iniciar com dados em memória e adicionar persistência depois.

Obrigado — se quiser, eu posso:
- Gerar a collection do Insomnia/Postman a partir dos exemplos; ou
- Adicionar um script `start-api.bat` que inicia o exe e abre o browser.

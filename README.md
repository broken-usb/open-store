# Open Store

Um **marketplace web simples** inspirado no Facebook Marketplace, desenvolvido em Java com foco em aprendizado e demonstração de tecnologias modernas do ecossistema Java.

---

## 🛠️ Tecnologias Utilizadas

- **Java 21**
- **Apache Tomcat v11.0.7**
- **Eclipse IDE for Java Enterprise and Web Developer**
- **Gson v2.13.1** – para manipulação de JSON
- **MySQL v8.0.42**
- **MySQL JDBC Driver v9.3.0**

> **Nota:** Este é um projeto com fins educacionais, focado na prática de desenvolvimento full-stack com Java EE e integração com banco de dados.

---

## ✨ Funcionalidades

- Cadastro e autenticação de usuários
- Cadastro e gerenciamento de produtos
- Sistema de pedidos
- Interface web responsiva

---

## 🧪 Como Executar Localmente

### Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Java JDK 21** ou superior
- **Apache Tomcat 11+**
- **MySQL 8.0+**
- **Eclipse IDE for Java Enterprise** (ou IDE de sua preferência)

### Passos para Instalação

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/open-store.git
   cd open-store
   ```

2. **Importe o projeto no Eclipse:**
   - Abra o Eclipse IDE
   - Vá em `File` → `Import` → `Existing Projects into Workspace`
   - Selecione o diretório do projeto clonado
   - Certifique-se de que o projeto seja reconhecido como **Dynamic Web Project**

3. **Configure o Apache Tomcat:**
   - No Eclipse, vá em `Window` → `Preferences` → `Server` → `Runtime Environments`
   - Clique em `Add` e selecione `Apache Tomcat v11.0`
   - Configure o caminho de instalação do Tomcat

4. **Configure o banco de dados:**
   - Crie o banco de dados MySQL usando o script fornecido abaixo
   - Atualize as credenciais de conexão no arquivo de configuração do projeto

5. **Crie o banco de dados:**

<details>
  <summary><strong>📄 Script do Banco de Dados</strong></summary>

  ```sql
CREATE DATABASE open_store;
USE open_store;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    id_comprador INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES produtos(id),
    FOREIGN KEY (id_comprador) REFERENCES usuarios(id)
);
  ```
</details>

6. **Execute o projeto:**
   - No Eclipse, clique com o botão direito no projeto
   - Selecione `Run As` → `Run on Server`
   - Escolha o servidor Tomcat configurado

7. **Acesse a aplicação:**
   ```
   http://localhost:8080/Open-Store/
   ```

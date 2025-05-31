# Open Store

Um **marketplace web simples**, inspirado no Facebook Marketplace, desenvolvido em Java com foco em aprendizado e demonstração de tecnologias modernas do ecossistema Java.

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

## 🧪 Como Executar Localmente

### Pré-requisitos

- Java JDK 21
- Apache Tomcat 11+
- MySQL 8.0+
- Eclipse IDE for Java Enterprise

### Passos

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/seu-repositorio.git

2. Importe o projeto no Eclipse como um **Dynamic Web Project** (`Projeto Web Dinâmico`).

3. Configure o **Apache Tomcat v11** no Eclipse, se ainda não estiver configurado.

4. Configure a conexão com o banco de dados no seu código-fonte, atualizando o host, usuário e senha conforme seu ambiente (geralmente em uma classe DAO ou arquivo de configuração).
5. No seu MySQL, crie o banco de dados utilizando o seguinte script:

<details>
  <summary><strong>📄 Script do Banco</strong></summary>

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

6. Execute o projeto no servidor Tomcat pelo Eclipse (botão direito no projeto → Run on Server).

7. Acesse a aplicação via navegador:
http://localhost:8080/Open-Store/

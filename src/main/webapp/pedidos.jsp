<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="modelo.entidade.Usuario"%>
<%
// Verificar se o usuário está logado
Usuario usuarioLogado = (Usuario) session.getAttribute("usuario");
if (usuarioLogado == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Finalizar Compra</title>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Ubuntu', 'Segoe UI', system-ui, -apple-system, sans-serif;
    background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
    min-height: 100vh;
    color: #ffffff;
    line-height: 1.6;
}

.container {
    max-width: 700px;
    margin: 0 auto;
    padding: 20px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.main-card {
    background: rgba(40, 40, 40, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 16px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
    overflow: hidden;
    border: 1px solid rgba(230, 126, 34, 0.2);
}

.header {
    background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
    padding: 30px;
    text-align: center;
    position: relative;
    overflow: hidden;
}

.header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="%23ffffff" fill-opacity="0.05"><circle cx="30" cy="30" r="2"/></g></svg>');
    opacity: 0.3;
}

.header h1 {
    font-size: 2.5rem;
    font-weight: 300;
    color: white;
    margin: 0;
    position: relative;
    z-index: 1;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.content {
    padding: 40px;
}

#message-container {
    margin-bottom: 30px;
}

.produto-info {
    background: linear-gradient(135deg, rgba(230, 126, 34, 0.1) 0%, rgba(211, 84, 0, 0.1) 100%);
    border: 1px solid rgba(230, 126, 34, 0.3);
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 30px;
    position: relative;
    overflow: hidden;
}

.produto-info::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: linear-gradient(180deg, #e67e22 0%, #d35400 100%);
}

.produto-info h3 {
    color: #e67e22;
    font-size: 1.4rem;
    margin-bottom: 15px;
    font-weight: 500;
}

.produto-info #produto-detalhes {
    color: #cccccc;
    line-height: 1.8;
}

.form-group {
    margin-bottom: 25px;
}

label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #e67e22;
    font-size: 1.1rem;
}

input[type="email"], select {
    width: 100%;
    padding: 15px 20px;
    background: rgba(255, 255, 255, 0.05);
    border: 2px solid rgba(230, 126, 34, 0.3);
    border-radius: 8px;
    color: #ffffff;
    font-size: 16px;
    transition: all 0.3s ease;
    backdrop-filter: blur(5px);
}

input[type="email"]:focus, select:focus {
    border-color: #e67e22;
    outline: none;
    box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.2);
    background: rgba(255, 255, 255, 0.08);
}

input[type="email"]::placeholder {
    color: rgba(255, 255, 255, 0.5);
}

small {
    color: rgba(255, 255, 255, 0.6);
    font-style: italic;
}

.buttons {
    text-align: center;
    margin-top: 40px;
    display: flex;
    gap: 15px;
    justify-content: center;
    flex-wrap: wrap;
}

button {
    padding: 15px 30px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 16px;
    font-weight: 500;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    position: relative;
    overflow: hidden;
    min-width: 140px;
}

button::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s;
}

button:hover::before {
    left: 100%;
}

.btn-finalizar {
    background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
    color: white;
    box-shadow: 0 4px 15px rgba(230, 126, 34, 0.4);
}

.btn-finalizar:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(230, 126, 34, 0.6);
}

.btn-cancelar {
    background: linear-gradient(135deg, #666666 0%, #555555 100%);
    color: white;
    box-shadow: 0 4px 15px rgba(102, 102, 102, 0.3);
}

.btn-cancelar:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(102, 102, 102, 0.5);
}

.btn-voltar {
    background: linear-gradient(135deg, #e67e22 0%, #d35400 100%);
    color: white;
    box-shadow: 0 4px 15px rgba(230, 126, 34, 0.4);
}

.btn-voltar:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(230, 126, 34, 0.6);
}

.message {
    padding: 20px;
    margin: 20px 0;
    border-radius: 8px;
    text-align: center;
    font-weight: 500;
    backdrop-filter: blur(5px);
    border: 1px solid;
}

.success {
    background: rgba(39, 174, 96, 0.2);
    color: #2ecc71;
    border-color: rgba(39, 174, 96, 0.4);
}

.error {
    background: rgba(231, 76, 60, 0.2);
    color: #e74c3c;
    border-color: rgba(231, 76, 60, 0.4);
}

.preco {
    font-size: 2.2rem;
    font-weight: 300;
    color: #e67e22;
    text-align: center;
    margin: 25px 0;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.success-container {
    text-align: center;
    padding: 50px 40px;
}

.success-icon {
    font-size: 4rem;
    color: #2ecc71;
    margin-bottom: 25px;
    text-shadow: 0 4px 8px rgba(46, 204, 113, 0.3);
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

.success-title {
    font-size: 2.5rem;
    color: #2ecc71;
    margin-bottom: 25px;
    font-weight: 300;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.pedido-detalhes {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(230, 126, 34, 0.2);
    border-radius: 12px;
    padding: 30px;
    margin: 30px 0;
    text-align: left;
    backdrop-filter: blur(5px);
}

.pedido-detalhes h4 {
    color: #e67e22;
    font-size: 1.4rem;
    margin-bottom: 20px;
    font-weight: 500;
}

.pedido-detalhes p {
    margin-bottom: 12px;
    color: #cccccc;
    line-height: 1.6;
}

.pedido-detalhes strong {
    color: #e67e22;
}

.hidden {
    display: none;
}

/* Responsive Design */
@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    
    .content {
        padding: 25px;
    }
    
    .header {
        padding: 25px;
    }
    
    .header h1 {
        font-size: 2rem;
    }
    
    .buttons {
        flex-direction: column;
        align-items: center;
    }
    
    button {
        width: 100%;
        max-width: 300px;
    }
}

/* Loading Animation */
@keyframes loading {
    0% { opacity: 0.5; }
    50% { opacity: 1; }
    100% { opacity: 0.5; }
}

.loading {
    animation: loading 1.5s infinite;
}
</style>
</head>
<body>
    <div class="container">
        <div class="main-card">
            <div class="header">
                <h1>Finalizar Compra</h1>
            </div>
            
            <div class="content">
                <div id="message-container"></div>

                <!-- Formulário de compra -->
                <div id="compra-form-container">
                    <div id="produto-info" class="produto-info">
                        <h3>Produto Selecionado</h3>
                        <div id="produto-detalhes" class="loading">Carregando...</div>
                        <div id="produto-preco" class="preco"></div>
                    </div>

                    <form id="pedido-form">
                        <div class="form-group">
                            <label for="email-comprador">Seu Email:</label> 
                            <input type="email" id="email-comprador" name="email" required
                                placeholder="Digite seu email para identificação"
                                value="<%=usuarioLogado.getEmail()%>" readonly> 
                            <small>Email do usuário logado</small>
                        </div>

                        <div class="buttons">
                            <button type="submit" class="btn-finalizar">Finalizar Compra</button>
                            <button type="button" class="btn-cancelar" onclick="cancelarCompra()">Cancelar</button>
                        </div>
                    </form>
                </div>

                <!-- Tela de sucesso -->
                <div id="success-container" class="success-container hidden">
                    <div class="success-icon">✓</div>
                    <div class="success-title">Pedido feito!</div>
                    <div class="success message">Sua compra foi realizada com sucesso!</div>

                    <div id="pedido-detalhes" class="pedido-detalhes">
                        <!-- Detalhes do pedido serão preenchidos aqui -->
                    </div>

                    <div class="buttons">
                        <button type="button" class="btn-voltar" onclick="voltarProdutos()">
                            Voltar aos Produtos
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let produtoId = null;
        let produtoAtual = null;
        
        // Dados do usuário logado
        const usuarioLogado = {
            id: <%=usuarioLogado.getId()%>,
            nome: '<%=usuarioLogado.getNome()%>',
            email: '<%=usuarioLogado.getEmail()%>'
        };
        
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        }
        
        function formatarPreco(preco) {
            return 'R$ ' + preco.toFixed(2).replace('.', ',');
        }
        
        function formatarDataHora(dataHora) {
            const data = new Date(dataHora);
            return data.toLocaleString('pt-BR');
        }
        
        function showMessage(message, type) {
            const container = document.getElementById('message-container');
            container.innerHTML = `<div class="message ${type}">${message}</div>`;
        }
        
        function clearMessages() {
            document.getElementById('message-container').innerHTML = '';
        }
        
        function carregarProduto() {
            produtoId = getUrlParameter('produto');
            
            if (!produtoId) {
                showMessage('Produto não especificado!', 'error');
                return;
            }
            
            fetch(`produtos/${produtoId}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Produto não encontrado');
                    }
                    return response.json();
                })
                .then(produto => {
                    produtoAtual = produto;
                    const detalhesElement = document.getElementById('produto-detalhes');
                    detalhesElement.classList.remove('loading');
                    detalhesElement.innerHTML = `
                        <strong>${produto.nome}</strong><br>
                        ${produto.descricao || 'Sem descrição'}<br>
                        <small>Vendedor: ${produto.usuario ? produto.usuario.nome : 'N/A'}</small>
                    `;
                    document.getElementById('produto-preco').textContent = formatarPreco(produto.preco);
                })
                .catch(error => {
                    console.error('Erro:', error);
                    document.getElementById('produto-detalhes').classList.remove('loading');
                    showMessage('Erro ao carregar produto!', 'error');
                });
        }
        
        function mostrarSucesso(pedido) {
            // Ocultar formulário de compra
            document.getElementById('compra-form-container').classList.add('hidden');
            
            // Preencher detalhes do pedido
            document.getElementById('pedido-detalhes').innerHTML = 
                '<h4>Detalhes do Pedido</h4>' +
                '<p><strong>Número do Pedido:</strong> #' + pedido.id + '</p>' +
                '<p><strong>Produto:</strong> ' + produtoAtual.nome + '</p>' +
                '<p><strong>Descrição:</strong> ' + (produtoAtual.descricao || 'Sem descrição') + '</p>' +
                '<p><strong>Preço:</strong> ' + formatarPreco(produtoAtual.preco) + '</p>' +
                '<p><strong>Vendedor:</strong> ' + (produtoAtual.usuario ? produtoAtual.usuario.nome : 'N/A') + '</p>' +
                '<p><strong>Comprador:</strong> ' + usuarioLogado.nome + '</p>' +
                '<p><strong>Data do Pedido:</strong> ' + formatarDataHora(pedido.dataPedido) + '</p>';
            
            // Mostrar tela de sucesso
            document.getElementById('success-container').classList.remove('hidden');
            
            // Limpar mensagens de erro
            clearMessages();
        }
        
        document.getElementById('pedido-form').addEventListener('submit', function(e) {
            e.preventDefault();
            clearMessages();
            
            if (!produtoId || !produtoAtual) {
                showMessage('Produto não especificado!', 'error');
                return;
            }
            
            // Criar pedido usando JSON
            const pedidoData = {
                idProduto: parseInt(produtoId),
                idComprador: usuarioLogado.id
            };
            
            fetch('pedidos', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(pedidoData)
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(error => {
                        throw new Error(error.erro || 'Erro ao criar pedido');
                    });
                }
                return response.json();
            })
            .then(pedido => {
                mostrarSucesso(pedido);
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao finalizar compra: ' + error.message, 'error');
            });
        });
        
        function cancelarCompra() {
            if (confirm('Deseja cancelar a compra?')) {
                window.location.href = 'produtos.jsp';
            }
        }
        
        function voltarProdutos() {
            window.location.href = 'produtos.jsp';
        }
        
        // Carregar produto quando a página carregar
        document.addEventListener('DOMContentLoaded', carregarProduto);
    </script>
</body>
</html>
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
body {
	font-family: Arial, sans-serif;
	max-width: 600px;
	margin: 50px auto;
	padding: 20px;
	background-color: #f5f5f5;
}

.container {
	background-color: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
	color: #333;
	text-align: center;
	margin-bottom: 30px;
}

.produto-info {
	background-color: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	margin-bottom: 20px;
	border-left: 4px solid #4CAF50;
}

.form-group {
	margin-bottom: 20px;
}

label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
	color: #333;
}

input[type="email"], select {
	width: 100%;
	padding: 10px;
	border: 2px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
	font-size: 16px;
}

input[type="email"]:focus, select:focus {
	border-color: #4CAF50;
	outline: none;
}

.buttons {
	text-align: center;
	margin-top: 30px;
}

button {
	padding: 12px 25px;
	margin: 0 10px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 16px;
	font-weight: bold;
}

.btn-finalizar {
	background-color: #4CAF50;
	color: white;
}

.btn-finalizar:hover {
	background-color: #45a049;
}

.btn-cancelar {
	background-color: #f44336;
	color: white;
}

.btn-cancelar:hover {
	background-color: #da190b;
}

.btn-voltar {
	background-color: #2196F3;
	color: white;
}

.btn-voltar:hover {
	background-color: #1976D2;
}

.message {
	padding: 15px;
	margin: 20px 0;
	border-radius: 4px;
	text-align: center;
}

.success {
	background-color: #d4edda;
	color: #155724;
	border: 1px solid #c3e6cb;
}

.error {
	background-color: #f8d7da;
	color: #721c24;
	border: 1px solid #f5c6cb;
}

.preco {
	font-size: 24px;
	font-weight: bold;
	color: #2196F3;
	text-align: center;
	margin: 20px 0;
}

.success-container {
	text-align: center;
	padding: 40px 20px;
}

.success-icon {
	font-size: 48px;
	color: #4CAF50;
	margin-bottom: 20px;
}

.success-title {
	font-size: 28px;
	color: #4CAF50;
	margin-bottom: 20px;
	font-weight: bold;
}

.pedido-detalhes {
	background-color: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	margin: 20px 0;
	text-align: left;
}

.hidden {
	display: none;
}
</style>
</head>
<body>
	<div class="container">
		<h1>Finalizar Compra</h1>

		<div id="message-container"></div>

		<!-- Formulário de compra -->
		<div id="compra-form-container">
			<div id="produto-info" class="produto-info">
				<h3>Produto Selecionado</h3>
				<div id="produto-detalhes">Carregando...</div>
				<div id="produto-preco" class="preco"></div>
			</div>

			<form id="pedido-form">
				<div class="form-group">
					<label for="email-comprador">Seu Email:</label> <input type="email"
						id="email-comprador" name="email" required
						placeholder="Digite seu email para identificação"
						value="<%=usuarioLogado.getEmail()%>" readonly> <small
						style="color: #666;">Email do usuário logado</small>
				</div>

				<div class="buttons">
					<button type="submit" class="btn-finalizar">Finalizar
						Compra</button>
					<button type="button" class="btn-cancelar"
						onclick="cancelarCompra()">Cancelar</button>
				</div>
			</form>
		</div>

		<!-- Tela de sucesso -->
		<div id="success-container" class="success-container hidden">
			<div class="success-icon">✓</div>
			<div class="success-title">Pedido feito!</div>
			<div class="success message">Sua compra foi realizada com
				sucesso!</div>

			<div id="pedido-detalhes" class="pedido-detalhes">
				<!-- Detalhes do pedido serão preenchidos aqui -->
			</div>

			<div class="buttons">
				<button type="button" class="btn-voltar" onclick="voltarProdutos()">
					Voltar aos Produtos</button>
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
                    document.getElementById('produto-detalhes').innerHTML = `
                        <strong>${produto.nome}</strong><br>
                        ${produto.descricao || 'Sem descrição'}<br>
                        <small>Vendedor: ${produto.usuario ? produto.usuario.nome : 'N/A'}</small>
                    `;
                    document.getElementById('produto-preco').textContent = formatarPreco(produto.preco);
                })
                .catch(error => {
                    console.error('Erro:', error);
                    showMessage('Erro ao carregar produto!', 'error');
                });
        }
        
        function mostrarSucesso(pedido) {
            // Ocultar formulário de compra
            document.getElementById('compra-form-container').classList.add('hidden');
            
            // Preencher detalhes do pedido - CORREÇÃO: usar concatenação em vez de template literals
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
            
            // Criar pedido usando JSON (formato esperado pelo servlet)
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
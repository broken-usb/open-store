<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
</style>
</head>
<body>
	<div class="container">
		<h1>Finalizar Compra</h1>

		<div id="message-container"></div>

		<div id="produto-info" class="produto-info">
			<h3>Produto Selecionado</h3>
			<div id="produto-detalhes">Carregando...</div>
			<div id="produto-preco" class="preco"></div>
		</div>

		<form id="pedido-form">
			<div class="form-group">
				<label for="email-comprador">Seu Email:</label> <input type="email"
					id="email-comprador" name="email" required
					placeholder="Digite seu email para identificação">
			</div>

			<div class="buttons">
				<button type="submit" class="btn-finalizar">Finalizar
					Compra</button>
				<button type="button" class="btn-cancelar"
					onclick="cancelarCompra()">Cancelar</button>
			</div>
		</form>
	</div>

	<script>
        let produtoId = null;
        let usuarioId = null;
        
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        }
        
        function formatarPreco(preco) {
            return 'R$ ' + preco.toFixed(2).replace('.', ',');
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
        
        function buscarUsuarioPorEmail(email) {
            return fetch('/usuarios')
                .then(response => response.json())
                .then(usuarios => {
                    const usuario = usuarios.find(u => u.email === email);
                    if (!usuario) {
                        throw new Error('Usuário não encontrado');
                    }
                    return usuario;
                });
        }
        
        document.getElementById('pedido-form').addEventListener('submit', function(e) {
            e.preventDefault();
            clearMessages();
            
            const email = document.getElementById('email-comprador').value;
            
            if (!produtoId) {
                showMessage('Produto não especificado!', 'error');
                return;
            }
            
            // Buscar usuário pelo email
            buscarUsuarioPorEmail(email)
                .then(usuario => {
                    usuarioId = usuario.id;
                    
                    // Criar pedido
                    const formData = new FormData();
                    formData.append('idProduto', produtoId);
                    formData.append('idComprador', usuarioId);
                    
                    return fetch('pedidos', {
                        method: 'POST',
                        body: formData
                    });
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro ao criar pedido');
                    }
                    return response.json();
                })
                .then(pedido => {
                    showMessage('Compra realizada com sucesso!', 'success');
                    document.getElementById('pedido-form').reset();
                    
                    setTimeout(() => {
                        window.location.href = 'produtos.jsp';
                    }, 2000);
                })
                .catch(error => {
                    console.error('Erro:', error);
                    if (error.message === 'Usuário não encontrado') {
                        showMessage('Email não cadastrado! Faça seu cadastro primeiro.', 'error');
                    } else {
                        showMessage('Erro ao finalizar compra!', 'error');
                    }
                });
        });
        
        function cancelarCompra() {
            if (confirm('Deseja cancelar a compra?')) {
                window.location.href = 'produtos.jsp';
            }
        }
        
        // Carregar produto quando a página carregar
        document.addEventListener('DOMContentLoaded', carregarProduto);
    </script>
</body>
</html>
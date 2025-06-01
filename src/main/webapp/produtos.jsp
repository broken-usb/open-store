<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Gerenciamento de Produtos</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
	background-color: #f5f5f5;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
	background-color: white;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
	color: #333;
	text-align: center;
	margin-bottom: 30px;
}

.header-actions {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.btn {
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
	text-decoration: none;
	display: inline-block;
	text-align: center;
}

.btn-primary {
	background-color: #4CAF50;
	color: white;
}

.btn-secondary {
	background-color: #2196F3;
	color: white;
}

.btn-danger {
	background-color: #f44336;
	color: white;
}

.btn:hover {
	opacity: 0.8;
}

.btn-small {
	padding: 5px 10px;
	font-size: 12px;
	margin: 0 2px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

th, td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #4CAF50;
	color: white;
	font-weight: bold;
}

tr:hover {
	background-color: #f5f5f5;
}

.preco {
	text-align: right;
	font-weight: bold;
	color: #2196F3;
}

.acoes {
	text-align: center;
	width: 150px;
}

.loading {
	text-align: center;
	padding: 20px;
	color: #666;
}

.error {
	text-align: center;
	padding: 20px;
	color: #f44336;
	background-color: #ffebee;
	border-radius: 4px;
	margin: 20px 0;
}

.empty {
	text-align: center;
	padding: 40px;
	color: #666;
	font-style: italic;
}

.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fefefe;
	margin: 10% auto;
	padding: 20px;
	border-radius: 8px;
	width: 500px;
	max-width: 90%;
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
}

.close:hover {
	color: black;
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group textarea, .form-group select {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

.form-group textarea {
	height: 80px;
	resize: vertical;
}

.form-actions {
	text-align: right;
	margin-top: 20px;
}

.success {
	text-align: center;
	padding: 15px;
	color: #4CAF50;
	background-color: #e8f5e8;
	border-radius: 4px;
	margin: 20px 0;
}

.search-bar {
	margin-bottom: 20px;
}

.search-bar input {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	width: 300px;
}
</style>
</head>
<body>
	<div class="container">
		<h1>Gerenciamento de Produtos</h1>

		<div class="header-actions">
			<div class="search-bar">
				<input type="text" id="campoBusca"
					placeholder="Buscar produtos por nome..."
					onkeyup="buscarProdutos()">
			</div>
			<button class="btn btn-primary" onclick="abrirModalProduto()">
				Adicionar Produto</button>
		</div>

		<div id="loading" class="loading">Carregando produtos...</div>
		<div id="error" class="error" style="display: none;">Erro ao
			carregar produtos. Tente novamente.</div>
		<div id="success" class="success" style="display: none;"></div>

		<table id="tabelaProdutos" style="display: none;">
			<thead>
				<tr>
					<th>ID</th>
					<th>Nome</th>
					<th>Descrição</th>
					<th>Preço</th>
					<th>Usuário</th>
					<th class="acoes">Ações</th>
				</tr>
			</thead>
			<tbody id="corpoTabela">
			</tbody>
		</table>

		<div id="empty" class="empty" style="display: none;">Nenhum
			produto encontrado.</div>
	</div>

	<!-- Modal para Adicionar/Editar Produto -->
	<div id="modalProduto" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h2 id="tituloModal">Adicionar Produto</h2>
				<span class="close" onclick="fecharModalProduto()">&times;</span>
			</div>
			<form id="formProduto">
				<input type="hidden" id="produtoId" name="id">

				<div class="form-group">
					<label for="nome">Nome do Produto:</label> <input type="text"
						id="nome" name="nome" required>
				</div>

				<div class="form-group">
					<label for="descricao">Descrição:</label>
					<textarea id="descricao" name="descricao"></textarea>
				</div>

				<div class="form-group">
					<label for="preco">Preço:</label> <input type="number" id="preco"
						name="preco" step="0.01" min="0" required>
				</div>

				<div class="form-group">
					<label for="idUsuario">Usuário:</label> <select id="idUsuario"
						name="idUsuario" required>
						<option value="">Selecione um usuário</option>
					</select>
				</div>

				<div class="form-actions">
					<button type="button" class="btn" onclick="fecharModalProduto()">Cancelar</button>
					<button type="submit" id="btnSalvar" class="btn btn-primary">Salvar</button>
				</div>
			</form>
		</div>
	</div>

	<script>
        let produtoAtual = null;
        let usuarios = [];

        // Função para formatar preço em Real
        function formatarPreco(preco) {
            return 'R$ ' + preco.toFixed(2).replace('.', ',');
        }

        // Função para mostrar mensagem de sucesso
        function mostrarSucesso(mensagem) {
            const div = document.getElementById('success');
            div.textContent = mensagem;
            div.style.display = 'block';
            setTimeout(() => {
                div.style.display = 'none';
            }, 3000);
        }

        // Função para carregar usuários
        function carregarUsuarios() {
            fetch('usuarios')
                .then(response => response.json())
                .then(data => {
                    usuarios = data;
                    const select = document.getElementById('idUsuario');
                    select.innerHTML = '<option value="">Selecione um usuário</option>';
                    
                    usuarios.forEach(usuario => {
                        const option = document.createElement('option');
                        option.value = usuario.id;
                        option.textContent = usuario.nome;
                        select.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Erro ao carregar usuários:', error);
                });
        }
        
        // Função para carregar produtos
        function carregarProdutos() {
            document.getElementById('loading').style.display = 'block';
            document.getElementById('error').style.display = 'none';
            document.getElementById('tabelaProdutos').style.display = 'none';
            document.getElementById('empty').style.display = 'none';

            fetch('produtos')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro na requisição');
                    }
                    return response.json();
                })
                .then(produtos => {
                    document.getElementById('loading').style.display = 'none';
                    
                    if (produtos.length === 0) {
                        document.getElementById('empty').style.display = 'block';
                        return;
                    }
                    
                    renderizarProdutos(produtos);
                })
                .catch(error => {
                    console.error('Erro:', error);
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('error').style.display = 'block';
                });
        }

        // Função para renderizar produtos na tabela
        function renderizarProdutos(produtos) {
            const corpoTabela = document.getElementById('corpoTabela');
            corpoTabela.innerHTML = '';
            
            produtos.forEach(produto => {
                const linha = document.createElement('tr');
                
                linha.innerHTML = 
                    '<td>' + produto.id + '</td>' +
                    '<td>' + produto.nome + '</td>' +
                    '<td>' + (produto.descricao || '-') + '</td>' +
                    '<td class="preco">' + formatarPreco(produto.preco) + '</td>' +
                    '<td>' + (produto.usuario ? produto.usuario.nome : 'N/A') + '</td>' +
                    '<td class="acoes">' +
                        '<button class="btn btn-secondary btn-small" onclick="comprarProduto(' + produto.id + ')">Comprar</button>' +
                        '<button class="btn btn-primary btn-small" onclick="editarProduto(' + produto.id + ')">Editar</button>' +
                        '<button class="btn btn-danger btn-small" onclick="excluirProduto(' + produto.id + ')">Excluir</button>' +
                    '</td>';
                
                corpoTabela.appendChild(linha);
            });
            
            document.getElementById('tabelaProdutos').style.display = 'table';
        }

        // Função para buscar produtos por nome
        function buscarProdutos() {
            const termo = document.getElementById('campoBusca').value.trim();
            
            if (termo === '') {
                carregarProdutos();
                return;
            }

            fetch('produtos?nome=' + encodeURIComponent(termo))
                .then(response => response.json())
                .then(produtos => {
                    renderizarProdutos(produtos);
                })
                .catch(error => {
                    console.error('Erro na busca:', error);
                });
        }

        // Função para comprar produto (redireciona para pedidos.jsp)
        function comprarProduto(idProduto) {
            // Redireciona para a página de pedidos com o ID do produto
            window.location.href = 'pedidos.jsp?produtoId=' + idProduto;
        }

        // Função para abrir modal de produto
        function abrirModalProduto() {
            produtoAtual = null;
            document.getElementById('tituloModal').textContent = 'Adicionar Produto';
            document.getElementById('btnSalvar').textContent = 'Salvar';
            document.getElementById('formProduto').reset();
            document.getElementById('produtoId').value = '';
            document.getElementById('modalProduto').style.display = 'block';
        }

        // Função para fechar modal
        function fecharModalProduto() {
            document.getElementById('modalProduto').style.display = 'none';
        }

        // Função para editar produto
        function editarProduto(id) {
            fetch('produtos?id=' + id)
                .then(response => response.json())
                .then(produto => {
                    produtoAtual = produto;
                    document.getElementById('tituloModal').textContent = 'Editar Produto';
                    document.getElementById('btnSalvar').textContent = 'Atualizar';
                    document.getElementById('produtoId').value = produto.id;
                    document.getElementById('nome').value = produto.nome;
                    document.getElementById('descricao').value = produto.descricao || '';
                    document.getElementById('preco').value = produto.preco;
                    document.getElementById('idUsuario').value = produto.usuario ? produto.usuario.id : '';
                    document.getElementById('modalProduto').style.display = 'block';
                })
                .catch(error => {
                    console.error('Erro ao carregar produto:', error);
                    alert('Erro ao carregar dados do produto');
                });
        }

        // Função para excluir produto
        function excluirProduto(id) {
            if (confirm('Tem certeza que deseja excluir este produto?')) {
                fetch('produtos?id=' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        mostrarSucesso('Produto excluído com sucesso!');
                        carregarProdutos();
                    } else {
                        throw new Error('Erro ao excluir produto');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao excluir produto');
                });
            }
        }

        // Função para salvar produto (criar ou atualizar)
        function salvarProduto(event) {
            event.preventDefault();
            
            const formData = new FormData(document.getElementById('formProduto'));
            const produto = {
                nome: formData.get('nome'),
                descricao: formData.get('descricao'),
                preco: parseFloat(formData.get('preco')),
                idUsuario: parseInt(formData.get('idUsuario'))
            };

            let url = 'produtos';
            let method = 'POST';

            if (produtoAtual) {
                produto.id = produtoAtual.id;
                method = 'PUT';
            }

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(produto)
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Erro ao salvar produto');
                }
            })
            .then(result => {
                fecharModalProduto();
                mostrarSucesso(produtoAtual ? 'Produto atualizado com sucesso!' : 'Produto criado com sucesso!');
                carregarProdutos();
            })
            .catch(error => {
                console.error('Erro:', error);
                alert('Erro ao salvar produto. Verifique os dados e tente novamente.');
            });
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            carregarUsuarios();
            carregarProdutos();
        });

        document.getElementById('formProduto').addEventListener('submit', salvarProduto);

        // Fechar modal ao clicar fora dele
        window.onclick = function(event) {
            const modal = document.getElementById('modalProduto');
            if (event.target == modal) {
                fecharModalProduto();
            }
        }
    </script>
</body>
</html>
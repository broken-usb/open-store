<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="modelo.entidade.Usuario"%>
<%
// Verificar se o usuário está logado (adicional ao filtro)
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

.user-info {
	display: flex;
	align-items: center;
	gap: 15px;
}

.user-welcome {
	font-weight: bold;
	color: #4CAF50;
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

.btn-warning {
	background-color: #ff9800;
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

.btn:disabled {
	opacity: 0.5;
	cursor: not-allowed;
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

.meu-produto {
	background-color: #e8f5e8;
}

.preco {
	text-align: right;
	font-weight: bold;
	color: #2196F3;
}

.acoes {
	text-align: center;
	width: 180px;
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

.filter-buttons {
	margin-bottom: 20px;
}

.filter-buttons button {
	margin-right: 10px;
}

.owner-badge {
	background-color: #4CAF50;
	color: white;
	padding: 2px 8px;
	border-radius: 12px;
	font-size: 11px;
	font-weight: bold;
}
</style>
</head>
<body>
	<div class="container">
		<h1>Gerenciamento de Produtos</h1>

		<div class="header-actions">
			<div class="user-info">
				<span class="user-welcome">Bem-vindo, <%=usuarioLogado.getNome()%>!
				</span> <a href="login?logout=true" class="btn btn-warning">Logout</a>
			</div>
			<button class="btn btn-primary" onclick="abrirModalProduto()">
				Adicionar Produto</button>
		</div>

		<div class="filter-buttons">
			<button class="btn btn-secondary" id="btnTodos"
				onclick="filtrarProdutos('todos')">Todos os Produtos</button>
			<button class="btn btn-primary" id="btnMeus"
				onclick="filtrarProdutos('meus')">Meus Produtos</button>
		</div>

		<div class="search-bar">
			<input type="text" id="campoBusca"
				placeholder="Buscar produtos por nome..." onkeyup="buscarProdutos()">
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

				<div class="form-actions">
					<button type="button" class="btn" onclick="fecharModalProduto()">Cancelar</button>
					<button type="submit" id="btnSalvar" class="btn btn-primary">Salvar</button>
				</div>
			</form>
		</div>
	</div>

	<script>
        let produtoAtual = null;
        let todosProdutos = []; // Cache de todos os produtos
        let filtroAtual = 'todos'; // 'todos' ou 'meus'
        
        // Dados do usuário logado
        const usuarioLogado = {
            id: <%=usuarioLogado.getId()%>,
            nome: '<%=usuarioLogado.getNome()%>',
            email: '<%=usuarioLogado.getEmail()%>'
        };

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

        // Função para verificar se o produto pertence ao usuário logado
        function ehMeuProduto(produto) {
            return produto.usuario && produto.usuario.id === usuarioLogado.id;
        }

        // Função para filtrar produtos
        function filtrarProdutos(tipo) {
            filtroAtual = tipo;
            
            // Atualizar estado dos botões
            document.getElementById('btnTodos').className = tipo === 'todos' ? 'btn btn-primary' : 'btn btn-secondary';
            document.getElementById('btnMeus').className = tipo === 'meus' ? 'btn btn-primary' : 'btn btn-secondary';
            
            let produtosFiltrados;
            if (tipo === 'meus') {
                produtosFiltrados = todosProdutos.filter(produto => ehMeuProduto(produto));
            } else {
                produtosFiltrados = todosProdutos;
            }
            
            renderizarProdutos(produtosFiltrados);
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
                    todosProdutos = produtos;
                    
                    if (produtos.length === 0) {
                        document.getElementById('empty').style.display = 'block';
                        return;
                    }
                    
                    // Aplicar filtro atual
                    filtrarProdutos(filtroAtual);
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
            
            if (produtos.length === 0) {
                document.getElementById('tabelaProdutos').style.display = 'none';
                document.getElementById('empty').style.display = 'block';
                return;
            }
            
            produtos.forEach(produto => {
                const linha = document.createElement('tr');
                const isMeuProduto = ehMeuProduto(produto);
                
                if (isMeuProduto) {
                    linha.className = 'meu-produto';
                }
                
                let acoes = '<button class="btn btn-secondary btn-small" onclick="comprarProduto(' + produto.id + ')">Comprar</button>';
                
                if (isMeuProduto) {
                    acoes += '<button class="btn btn-primary btn-small" onclick="editarProduto(' + produto.id + ')">Editar</button>' +
                            '<button class="btn btn-danger btn-small" onclick="excluirProduto(' + produto.id + ')">Excluir</button>';
                }
                
                let nomeUsuario = produto.usuario ? produto.usuario.nome : 'N/A';
                if (isMeuProduto) {
                    nomeUsuario += ' <span class="owner-badge">SEUS</span>';
                }
                
                linha.innerHTML = 
                    '<td>' + produto.id + '</td>' +
                    '<td>' + produto.nome + '</td>' +
                    '<td>' + (produto.descricao || '-') + '</td>' +
                    '<td class="preco">' + formatarPreco(produto.preco) + '</td>' +
                    '<td>' + nomeUsuario + '</td>' +
                    '<td class="acoes">' + acoes + '</td>';
                
                corpoTabela.appendChild(linha);
            });
            
            document.getElementById('tabelaProdutos').style.display = 'table';
            document.getElementById('empty').style.display = 'none';
        }

        // Função para buscar produtos por nome
        function buscarProdutos() {
            const termo = document.getElementById('campoBusca').value.trim().toLowerCase();
            
            if (termo === '') {
                filtrarProdutos(filtroAtual);
                return;
            }

            let produtosFiltrados = todosProdutos.filter(produto => 
                produto.nome.toLowerCase().includes(termo)
            );
            
            // Aplicar filtro adicional se necessário
            if (filtroAtual === 'meus') {
                produtosFiltrados = produtosFiltrados.filter(produto => ehMeuProduto(produto));
            }
            
            renderizarProdutos(produtosFiltrados);
        }

        // Função para comprar produto
        function comprarProduto(idProduto) {
            //window.location.href = 'pedidos.jsp?produtoId=' + idProduto;
        	window.location.href = 'pedidos.jsp?produto=' + idProduto;
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
            const produto = todosProdutos.find(p => p.id === id);
            
            if (!produto) {
                alert('Produto não encontrado');
                return;
            }
            
            if (!ehMeuProduto(produto)) {
                alert('Você só pode editar seus próprios produtos');
                return;
            }
            
            produtoAtual = produto;
            document.getElementById('tituloModal').textContent = 'Editar Produto';
            document.getElementById('btnSalvar').textContent = 'Atualizar';
            document.getElementById('produtoId').value = produto.id;
            document.getElementById('nome').value = produto.nome;
            document.getElementById('descricao').value = produto.descricao || '';
            document.getElementById('preco').value = produto.preco;
            document.getElementById('modalProduto').style.display = 'block';
        }

        // Função para excluir produto
        function excluirProduto(id) {
            const produto = todosProdutos.find(p => p.id === id);
            
            if (!produto) {
                alert('Produto não encontrado');
                return;
            }
            
            if (!ehMeuProduto(produto)) {
                alert('Você só pode excluir seus próprios produtos');
                return;
            }
            
            if (confirm('Tem certeza que deseja excluir o produto "' + produto.nome + '"?')) {
                fetch('produtos?id=' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        mostrarSucesso('Produto excluído com sucesso!');
                        carregarProdutos();
                    } else {
                        return response.json().then(error => {
                            throw new Error(error.erro || 'Erro ao excluir produto');
                        });
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao excluir produto: ' + error.message);
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
                idUsuario: usuarioLogado.id // Sempre usar o usuário logado
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
                    return response.json().then(error => {
                        throw new Error(error.erro || 'Erro ao salvar produto');
                    });
                }
            })
            .then(result => {
                fecharModalProduto();
                mostrarSucesso(produtoAtual ? 'Produto atualizado com sucesso!' : 'Produto criado com sucesso!');
                carregarProdutos();
            })
            .catch(error => {
                console.error('Erro:', error);
                alert('Erro ao salvar produto: ' + error.message);
            });
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
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
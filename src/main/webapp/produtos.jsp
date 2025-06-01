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
	font-family: 'Ubuntu', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		Arial, sans-serif;
	margin: 0;
	padding: 20px;
	background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
	color: #ffffff;
	min-height: 100vh;
}

.container {
	max-width: 1200px;
	margin: 0 auto;
	background: linear-gradient(145deg, #333333, #1e1e1e);
	padding: 30px;
	border-radius: 16px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3), inset 0 1px 0
		rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.1);
}

h1 {
	color: #ff6600;
	text-align: center;
	margin-bottom: 40px;
	font-size: 2.5em;
	font-weight: 300;
	text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
	position: relative;
}

h1:after {
	content: '';
	position: absolute;
	bottom: -10px;
	left: 50%;
	transform: translateX(-50%);
	width: 80px;
	height: 3px;
	background: linear-gradient(90deg, #ff6600, #ff8533);
	border-radius: 2px;
}

.header-actions {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	padding: 20px;
	background: rgba(0, 0, 0, 0.2);
	border-radius: 12px;
	border: 1px solid rgba(255, 102, 0, 0.2);
}

.user-info {
	display: flex;
	align-items: center;
	gap: 20px;
}

.user-welcome {
	font-weight: 500;
	color: #ff6600;
	font-size: 1.1em;
	text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.btn {
	padding: 12px 24px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	font-weight: 500;
	text-decoration: none;
	display: inline-block;
	text-align: center;
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.btn:before {
	content: '';
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2),
		transparent);
	transition: left 0.5s;
}

.btn:hover:before {
	left: 100%;
}

.btn-primary {
	background: linear-gradient(135deg, #ff6600, #ff8533);
	color: white;
	box-shadow: 0 4px 15px rgba(255, 102, 0, 0.3);
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(255, 102, 0, 0.4);
}

.btn-secondary {
	background: linear-gradient(135deg, #4a4a4a, #666666);
	color: white;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

.btn-secondary:hover {
	transform: translateY(-2px);
	background: linear-gradient(135deg, #666666, #808080);
}

.btn-danger {
	background: linear-gradient(135deg, #cc3300, #ff4444);
	color: white;
	box-shadow: 0 4px 15px rgba(204, 51, 0, 0.3);
}

.btn-danger:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(204, 51, 0, 0.4);
}

.btn-warning {
	background: linear-gradient(135deg, #ffaa00, #ffcc33);
	color: #1a1a1a;
	box-shadow: 0 4px 15px rgba(255, 170, 0, 0.3);
}

.btn-warning:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(255, 170, 0, 0.4);
}

.btn-small {
	padding: 8px 16px;
	font-size: 12px;
	margin: 0 3px;
}

.btn:disabled {
	opacity: 0.5;
	cursor: not-allowed;
	transform: none !important;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	background: rgba(0, 0, 0, 0.2);
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

th, td {
	padding: 16px;
	text-align: left;
	border-bottom: 1px solid rgba(255, 102, 0, 0.2);
}

th {
	background: linear-gradient(135deg, #ff6600, #ff8533);
	color: white;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 1px;
	text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

tr:hover {
	background: rgba(255, 102, 0, 0.1);
	transform: scale(1.01);
	transition: all 0.2s ease;
}

.meu-produto {
	background: linear-gradient(135deg, rgba(255, 102, 0, 0.15),
		rgba(255, 133, 51, 0.1));
	border-left: 4px solid #ff6600;
}

.preco {
	text-align: right;
	font-weight: bold;
	color: #ff6600;
	font-size: 1.1em;
}

.acoes {
	text-align: center;
	width: 200px;
}

.loading, .error, .empty {
	text-align: center;
	padding: 40px;
	border-radius: 12px;
	margin: 20px 0;
}

.loading {
	color: #ff6600;
	background: rgba(255, 102, 0, 0.1);
	border: 1px solid rgba(255, 102, 0, 0.3);
}

.error {
	color: #ff4444;
	background: rgba(204, 51, 0, 0.1);
	border: 1px solid rgba(204, 51, 0, 0.3);
}

.empty {
	color: #cccccc;
	font-style: italic;
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid rgba(255, 255, 255, 0.1);
}

.success {
	text-align: center;
	padding: 16px;
	color: #00cc66;
	background: rgba(0, 204, 102, 0.1);
	border-radius: 8px;
	margin: 20px 0;
	border: 1px solid rgba(0, 204, 102, 0.3);
}

.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.8);
	backdrop-filter: blur(5px);
}

.modal-content {
	background: linear-gradient(145deg, #333333, #1e1e1e);
	margin: 5% auto;
	padding: 30px;
	border-radius: 16px;
	width: 500px;
	max-width: 90%;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5), inset 0 1px 0
		rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 102, 0, 0.3);
	color: white;
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	padding-bottom: 15px;
	border-bottom: 2px solid rgba(255, 102, 0, 0.3);
}

.modal-header h2 {
	color: #ff6600;
	margin: 0;
	font-size: 1.8em;
	font-weight: 300;
}

.close {
	color: #ff6600;
	font-size: 32px;
	font-weight: bold;
	cursor: pointer;
	transition: all 0.3s ease;
	width: 40px;
	height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	background: rgba(255, 102, 0, 0.1);
}

.close:hover {
	background: rgba(255, 102, 0, 0.2);
	transform: rotate(90deg);
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
	color: #ff6600;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	font-size: 0.9em;
}

.form-group input, .form-group textarea, .form-group select {
	width: 100%;
	padding: 12px 16px;
	border: 2px solid rgba(255, 102, 0, 0.3);
	border-radius: 8px;
	box-sizing: border-box;
	background: rgba(0, 0, 0, 0.3);
	color: white;
	font-size: 14px;
	transition: all 0.3s ease;
}

.form-group input:focus, .form-group textarea:focus, .form-group select:focus
	{
	outline: none;
	border-color: #ff6600;
	box-shadow: 0 0 0 3px rgba(255, 102, 0, 0.2);
	background: rgba(0, 0, 0, 0.5);
}

.form-group textarea {
	height: 100px;
	resize: vertical;
}

.form-actions {
	text-align: right;
	margin-top: 30px;
	gap: 15px;
	display: flex;
	justify-content: flex-end;
}

.search-bar {
	margin-bottom: 25px;
}

.search-bar input {
	padding: 15px 20px;
	border: 2px solid rgba(255, 102, 0, 0.3);
	border-radius: 25px;
	width: 350px;
	background: rgba(0, 0, 0, 0.3);
	color: white;
	font-size: 16px;
	transition: all 0.3s ease;
}

.search-bar input:focus {
	outline: none;
	border-color: #ff6600;
	box-shadow: 0 0 0 3px rgba(255, 102, 0, 0.2);
	background: rgba(0, 0, 0, 0.5);
}

.search-bar input::placeholder {
	color: rgba(255, 255, 255, 0.6);
}

.filter-buttons {
	margin-bottom: 25px;
	display: flex;
	gap: 15px;
}

.owner-badge {
	background: linear-gradient(135deg, #ff6600, #ff8533);
	color: white;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: bold;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	box-shadow: 0 2px 8px rgba(255, 102, 0, 0.3);
}

/* Animações suaves */
* {
	transition: all 0.2s ease;
}

/* Scrollbar customizada */
::-webkit-scrollbar {
	width: 12px;
}

::-webkit-scrollbar-track {
	background: #1a1a1a;
	border-radius: 6px;
}

::-webkit-scrollbar-thumb {
	background: linear-gradient(135deg, #ff6600, #ff8533);
	border-radius: 6px;
}

::-webkit-scrollbar-thumb:hover {
	background: linear-gradient(135deg, #ff8533, #ffaa66);
}

/* Efeitos de hover melhorados */
.container:hover {
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4), inset 0 1px 0
		rgba(255, 255, 255, 0.15);
}

/* Responsividade */
@media ( max-width : 768px) {
	.container {
		margin: 10px;
		padding: 20px;
	}
	.header-actions {
		flex-direction: column;
		gap: 15px;
	}
	.search-bar input {
		width: 100%;
	}
	.filter-buttons {
		flex-wrap: wrap;
	}
	table {
		font-size: 14px;
	}
	th, td {
		padding: 12px 8px;
	}
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
					<button type="button" class="btn btn-secondary"
						onclick="fecharModalProduto()">Cancelar</button>
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
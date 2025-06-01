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
	margin: 0;
	padding: 0;
	background-color: #f5f5f5;
}

.user-header {
	background-color: #4CAF50;
	color: white;
	padding: 10px 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.user-info {
	display: flex;
	align-items: center;
}

.user-name {
	margin-right: 10px;
	font-weight: bold;
}

.logout-btn {
	background-color: #f44336;
	color: white;
	border: none;
	padding: 8px 15px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 14px;
}

.logout-btn:hover {
	background-color: #d32f2f;
}

.container {
	max-width: 1200px;
	margin: 20px auto;
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
	width: 200px;
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

.not-authorized {
	text-align: center;
	padding: 40px;
	color: #f44336;
	background-color: #ffebee;
	border-radius: 8px;
	margin: 20px;
}

.loading-page {
	text-align: center;
	padding: 40px;
	color: #666;
}
</style>
</head>
<body>
	<!-- Header com informações do usuário -->
	<div class="user-header" id="userHeader" style="display: none;">
		<div class="user-info">
			<span>Bem-vindo, </span> <span class="user-name" id="userName">Carregando...</span>
		</div>
		<button class="logout-btn" onclick="logout()">Sair</button>
	</div>

	<!-- Tela de carregamento inicial -->
	<div id="loadingPage" class="loading-page">
		<h2>Verificando autenticação...</h2>
		<p>Aguarde um momento...</p>
	</div>

	<!-- Tela de não autorizado -->
	<div id="notAuthorized" class="not-authorized" style="display: none;">
		<h2>Acesso Negado</h2>
		<p>Você precisa estar logado para acessar esta página.</p>
		<button class="btn btn-primary" onclick="goToLogin()">Ir para
			Login</button>
	</div>

	<!-- Container principal -->
	<div class="container" id="mainContainer" style="display: none;">
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
        let usuarioLogado = null;
        const contextPath = '<%=request.getContextPath()%>';

        // Verificar se o usuário está logado ao carregar a página
        window.addEventListener('load', function() {
            verificarAutenticacao();
        });

        function verificarAutenticacao() {
            fetch(contextPath + '/verificar-sessao', {
                method: 'GET'
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Não autorizado');
                }
            })
            .then(usuario => {
                if (usuario && usuario.id) {
                    usuarioLogado = usuario;
                    mostrarPaginaAutorizada();
                } else {
                    mostrarPaginaNaoAutorizada();
                }
            })
            .catch(error => {
                console.error('Erro na verificação de autenticação:', error);
                mostrarPaginaNaoAutorizada();
            });
        }

        function mostrarPaginaAutorizada() {
            document.getElementById('loadingPage').style.display = 'none';
            document.getElementById('notAuthorized').style.display = 'none';
            document.getElementById('userHeader').style.display = 'flex';
            document.getElementById('mainContainer').style.display = 'block';
            
            // Mostrar nome do usuário
            document.getElementById('userName').textContent = usuarioLogado.nome;
            
            // Carregar dados
            carregarUsuarios();
            carregarProdutos();
        }

        function mostrarPaginaNaoAutorizada() {
            document.getElementById('loadingPage').style.display = 'none';
            document.getElementById('userHeader').style.display = 'none';
            document.getElementById('mainContainer').style.display = 'none';
            document.getElementById('notAuthorized').style.display = 'block';
        }

        function goToLogin() {
            window.location.href = contextPath + '/login.jsp';
        }

        function logout() {
            if (confirm('Tem certeza que deseja sair?')) {
                fetch(contextPath + '/login', {
                    method: 'GET'
                })
                .then(() => {
                    window.location.href = contextPath + '/login.jsp';
                })
                .catch(error => {
                    console.error('Erro no logout:', error);
                    // Mesmo com erro, redirecionar para login
                    window.location.href = contextPath + '/login.jsp';
                });
            }
        }

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
            fetch(contextPath + '/usuarios')
                .then(response => response.json())
                .then(data => {
                    usuarios = data;
                    const select = document.getElementById('idUsuario');
                    select.innerHTML = '<option value="">Selecione um usuário</option>';
                    
                    usuarios.forEach(usuario => {
                        const option = document.createElement('option');
                        option.value = usuario.id;
                        option.textContent = usuario.nome;
                        
                        // Pré-selecionar o usuário logado
                        if (usuarioLogado && usuario.id === usuarioLogado.id) {
                            option.selected = true;
                        }
                        
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

            fetch(contextPath + '/produtos')
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

            fetch(contextPath + '/produtos?nome=' + encodeURIComponent(termo))
                .then(response => response.json())
                .then(produtos => {
                    renderizarProdutos(produtos);
                })
                .catch(error => {
                    console.error('Erro na busca:', error);
                });
        }

        // Função para comprar produto (exemplo simples)
        function comprarProduto(idProduto) {
            alert('Funcionalidade de compra ainda não implementada para o produto ID: ' + idProduto);
        }

        // Função para abrir modal de produto
        function abrirModalProduto(produto = null) {
            produtoAtual = produto;
            const modal = document.getElementById('modalProduto');
            const titulo = document.getElementById('tituloModal');
            const form = document.getElementById('formProduto');
            
            if (produto) {
                titulo.textContent = 'Editar Produto';
                document.getElementById('produtoId').value = produto.id;
                document.getElementById('nome').value = produto.nome;
                document.getElementById('descricao').value = produto.descricao || '';
                document.getElementById('preco').value = produto.preco;
                document.getElementById('idUsuario').value = produto.usuario ? produto.usuario.id : '';
            } else {
                titulo.textContent = 'Adicionar Produto';
                form.reset();
                document.getElementById('produtoId').value = '';
                // Pré-selecionar usuário logado
                if (usuarioLogado) {
                    document.getElementById('idUsuario').value = usuarioLogado.id;
                }
            }
            
            modal.style.display = 'block';
        }

        // Função para fechar modal
        function fecharModalProduto() {
            document.getElementById('modalProduto').style.display = 'none';
            produtoAtual = null;
        }

        // Função para editar produto
        function editarProduto(id) {
            fetch(contextPath + '/produtos?id=' + id)
                .then(response => response.json())
                .then(produto => {
                    abrirModalProduto(produto);
                })
                .catch(error => {
                    console.error('Erro ao carregar produto:', error);
                    alert('Erro ao carregar dados do produto');
                });
        }

        // Função para excluir produto
        function excluirProduto(id) {
            if (confirm('Tem certeza que deseja excluir este produto?')) {
                fetch(contextPath + '/produtos?id=' + id, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        mostrarSucesso('Produto excluído com sucesso!');
                        carregarProdutos();
                    } else {
                        alert('Erro ao excluir produto');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao excluir produto');
                });
            }
        }

        // Submit do formulário
        document.getElementById('formProduto').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const id = document.getElementById('produtoId').value;
            const nome = document.getElementById('nome').value;
            const descricao = document.getElementById('descricao').value;
            const preco = parseFloat(document.getElementById('preco').value);
            const idUsuario = parseInt(document.getElementById('idUsuario').value);
            
            const produto = {
                nome: nome,
                descricao: descricao,
                preco: preco,
                idUsuario: idUsuario
            };
            
            if (id) {
                // Editar
                produto.id = parseInt(id);
                fetch(contextPath + '/produtos', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(produto)
                })
                .then(response => {
                    if (response.ok) {
                        mostrarSucesso('Produto atualizado com sucesso!');
                        fecharModalProduto();
                        carregarProdutos();
                    } else {
                        alert('Erro ao atualizar produto');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao atualizar produto');
                });
            } else {
                // Criar
                fetch(contextPath + '/produtos', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(produto)
                })
                .then(response => {
                    if (response.ok) {
                        mostrarSucesso('Produto criado com sucesso!');
                        fecharModalProduto();
                        carregarProdutos();
                    } else {
                        alert('Erro ao criar produto');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao criar produto');
                });
            }
        });

        // Fechar modal ao clicar fora
        window.onclick = function(event) {
            const modal = document.getElementById('modalProduto');
            if (event.target == modal) {
                fecharModalProduto();
            }
        }
    </script>
</body>
</html>
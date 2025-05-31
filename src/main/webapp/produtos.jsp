<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lista de Produtos</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
	background-color: #f5f5f5;
}

.container {
	max-width: 1000px;
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
</style>
</head>
<body>
	<div class="container">
		<h1>Lista de Produtos</h1>

		<div id="loading" class="loading">Carregando produtos...</div>

		<div id="error" class="error" style="display: none;">Erro ao
			carregar produtos. Tente novamente.</div>

		<table id="tabelaProdutos" style="display: none;">
			<thead>
				<tr>
					<th>ID</th>
					<th>Nome</th>
					<th>Descrição</th>
					<th>Preço</th>
					<th>Usuário</th>
				</tr>
			</thead>
			<tbody id="corpoTabela">
			</tbody>
		</table>

		<div id="empty" class="empty" style="display: none;">Nenhum
			produto encontrado.</div>
	</div>

	<script>
        // Função para formatar preço em Real
        function formatarPreco(preco) {
            return 'R$ ' + preco.toFixed(2).replace('.', ',');
        }
        
        // Função para carregar produtos
        function carregarProdutos() {
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
                    
                    const corpoTabela = document.getElementById('corpoTabela');
                    corpoTabela.innerHTML = '';
                    
                    produtos.forEach(produto => {
                        const linha = document.createElement('tr');
                        
                        linha.innerHTML = 
                            '<td>' + produto.id + '</td>' +
                            '<td>' + produto.nome + '</td>' +
                            '<td>' + (produto.descricao || '-') + '</td>' +
                            '<td class="preco">' + formatarPreco(produto.preco) + '</td>' +
                            '<td>' + (produto.usuario ? produto.usuario.nome : 'N/A') + '</td>';
                        
                        corpoTabela.appendChild(linha);
                    });
                    
                    document.getElementById('tabelaProdutos').style.display = 'table';
                })
                .catch(error => {
                    console.error('Erro:', error);
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('error').style.display = 'block';
                });
        }
        
        // Carregar produtos quando a página carregar
        document.addEventListener('DOMContentLoaded', carregarProdutos);
    </script>
</body>
</html>
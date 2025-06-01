<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login / Cadastro</title>
<style>
body {
	font-family: Arial, sans-serif;
	max-width: 400px;
	margin: 50px auto;
	padding: 20px;
}

.form-container {
	border: 1px solid #ddd;
	padding: 20px;
	border-radius: 5px;
	margin-bottom: 20px;
}

input[type="text"], input[type="email"], input[type="password"] {
	width: 100%;
	padding: 8px;
	margin: 5px 0 15px 0;
	border: 1px solid #ddd;
	border-radius: 3px;
	box-sizing: border-box;
}

button {
	background-color: #4CAF50;
	color: white;
	padding: 10px 15px;
	border: none;
	border-radius: 3px;
	cursor: pointer;
	margin-right: 10px;
}

button:hover {
	background-color: #45a049;
}

button:disabled {
	background-color: #cccccc;
	cursor: not-allowed;
}

.toggle-btn {
	background-color: #008CBA;
}

.toggle-btn:hover {
	background-color: #007B9A;
}

.message {
	padding: 10px;
	margin: 10px 0;
	border-radius: 3px;
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

.loading {
	background-color: #d1ecf1;
	color: #0c5460;
	border: 1px solid #bee5eb;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

th, td {
	padding: 8px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #f2f2f2;
}
</style>
</head>
<body>
	<h2 id="form-title">Login</h2>

	<div id="message-container"></div>

	<div class="form-container">
		<form id="user-form">
			<div id="nome-field" style="display: none;">
				<label for="nome">Nome:</label> <input type="text" id="nome"
					name="nome">
			</div>

			<label for="email">Email:</label> <input type="email" id="email"
				name="email" required> <label for="senha">Senha:</label> <input
				type="password" id="senha" name="senha" required>

			<button type="submit" id="submit-btn">Entrar</button>
			<button type="button" class="toggle-btn" onclick="toggleForm()">Cadastrar</button>
		</form>
	</div>

	<div id="usuarios-list" style="display: none;">
		<h3>Usuários Cadastrados</h3>
		<div id="usuarios-container"></div>
		<button onclick="listarUsuarios()">Atualizar Lista</button>
		<button onclick="voltarLogin()">Voltar ao Login</button>
		<button onclick="logout()">Logout</button>
	</div>

	<script>
        let isLoginMode = true;
        const contextPath = '<%=request.getContextPath()%>';
        
        // Verificar se já está logado ao carregar a página
        window.addEventListener('load', function() {
            verificarSessao();
        });
        
        function verificarSessao() {
            // Verificar se há uma sessão ativa
            fetch(contextPath + '/verificar-sessao', {
                method: 'GET'
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Não logado');
            })
            .then(usuario => {
                // Se já está logado, redirecionar para produtos
                if (usuario && usuario.id) {
                    window.location.href = contextPath + '/produtos.jsp';
                }
            })
            .catch(error => {
                // Não está logado, continuar na página de login
                console.log('Usuário não está logado');
                testarConectividade();
            });
        }
        
        function testarConectividade() {
            fetch(contextPath + '/usuarios')
                .then(response => {
                    if (response.ok) {
                        console.log('Conexão com o servidor OK');
                    } else {
                        console.warn('Problema na conexão com o servidor');
                    }
                })
                .catch(error => {
                    console.error('Erro de conectividade:', error);
                    showMessage('Problema de conexão com o servidor', 'error');
                });
        }
        
        function toggleForm() {
            const formTitle = document.getElementById('form-title');
            const nomeField = document.getElementById('nome-field');
            const submitBtn = document.getElementById('submit-btn');
            const toggleBtn = document.querySelector('.toggle-btn');
            
            if (isLoginMode) {
                // Mudar para modo cadastro
                formTitle.textContent = 'Cadastro';
                nomeField.style.display = 'block';
                submitBtn.textContent = 'Cadastrar';
                toggleBtn.textContent = 'Login';
                document.getElementById('nome').required = true;
            } else {
                // Mudar para modo login
                formTitle.textContent = 'Login';
                nomeField.style.display = 'none';
                submitBtn.textContent = 'Entrar';
                toggleBtn.textContent = 'Cadastrar';
                document.getElementById('nome').required = false;
                document.getElementById('nome').value = '';
            }
            
            isLoginMode = !isLoginMode;
            clearMessages();
        }
        
        function showMessage(message, type) {
            const container = document.getElementById('message-container');
            container.innerHTML = '<div class="message ' + type + '">' + message + '</div>';
        }
        
        function clearMessages() {
            document.getElementById('message-container').innerHTML = '';
        }
        
        function setLoading(isLoading) {
            const submitBtn = document.getElementById('submit-btn');
            const toggleBtn = document.querySelector('.toggle-btn');
            
            submitBtn.disabled = isLoading;
            toggleBtn.disabled = isLoading;
            
            if (isLoading) {
                showMessage('Processando...', 'loading');
            }
        }
        
        document.getElementById('user-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value.trim();
            const senha = document.getElementById('senha').value;
            const nome = document.getElementById('nome').value.trim();
            
            if (!email || !senha) {
                showMessage('Email e senha são obrigatórios!', 'error');
                return;
            }
            
            if (!isLoginMode && !nome) {
                showMessage('Nome é obrigatório para cadastro!', 'error');
                return;
            }
            
            setLoading(true);
            
            if (isLoginMode) {
                // Login usando servlet dedicado
                const params = new URLSearchParams();
                params.append('email', email);
                params.append('senha', senha);
                
                fetch(contextPath + '/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                })
                .then(response => {
                    return response.json().then(data => {
                        if (response.ok) {
                            return data;
                        } else {
                            throw new Error(data.erro || 'Erro no login');
                        }
                    });
                })
                .then(usuario => {
                    showMessage('Bem-vindo, ' + usuario.nome + '! Redirecionando...', 'success');
                    // Redirecionar para a página de produtos após 1 segundo
                    setTimeout(() => {
                        window.location.href = contextPath + '/produtos.jsp';
                    }, 1000);
                })
                .catch(error => {
                    console.error('Erro no login:', error);
                    showMessage(error.message || 'Erro ao fazer login!', 'error');
                })
                .finally(() => {
                    setLoading(false);
                });
            } else {
                // Cadastro
                const params = new URLSearchParams();
                params.append('nome', nome);
                params.append('email', email);
                params.append('senha', senha);
                
                fetch(contextPath + '/usuarios', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: params
                })
                .then(response => {
                    return response.json().then(data => {
                        if (response.ok) {
                            return data;
                        } else {
                            throw new Error(data.erro || 'Erro no cadastro');
                        }
                    });
                })
                .then(data => {
                    showMessage('Usuário cadastrado com sucesso!', 'success');
                    document.getElementById('user-form').reset();
                    // Voltar para modo login após cadastro
                    setTimeout(() => {
                        if (!isLoginMode) toggleForm();
                    }, 1500);
                })
                .catch(error => {
                    console.error('Erro no cadastro:', error);
                    showMessage(error.message || 'Erro ao cadastrar usuário!', 'error');
                })
                .finally(() => {
                    setLoading(false);
                });
            }
        });
        
        function listarUsuarios() {
            fetch(contextPath + '/usuarios')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erro ao carregar usuários');
                    }
                    return response.json();
                })
                .then(usuarios => {
                    const container = document.getElementById('usuarios-container');
                    if (usuarios.length === 0) {
                        container.innerHTML = '<p>Nenhum usuário cadastrado.</p>';
                    } else {
                        let html = '<table>';
                        html += '<tr><th>ID</th><th>Nome</th><th>Email</th></tr>';
                        usuarios.forEach(usuario => {
                            html += '<tr>';
                            html += '<td>' + usuario.id + '</td>';
                            html += '<td>' + usuario.nome + '</td>';
                            html += '<td>' + usuario.email + '</td>';
                            html += '</tr>';
                        });
                        html += '</table>';
                        container.innerHTML = html;
                    }
                })
                .catch(error => {
                    console.error('Erro ao listar usuários:', error);
                    document.getElementById('usuarios-container').innerHTML = '<p>Erro ao carregar usuários.</p>';
                });
        }
        
        function logout() {
            fetch(contextPath + '/login', {
                method: 'GET'
            })
            .then(() => {
                voltarLogin();
            })
            .catch(error => {
                console.error('Erro no logout:', error);
                voltarLogin(); // Voltar mesmo com erro
            });
        }
        
        function voltarLogin() {
            document.querySelector('.form-container').style.display = 'block';
            document.getElementById('usuarios-list').style.display = 'none';
            document.getElementById('user-form').reset();
            clearMessages();
            if (!isLoginMode) toggleForm();
        }
    </script>
</body>
</html>
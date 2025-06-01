<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// Verificar se o usuário já está logado
if (session.getAttribute("usuario") != null) {
	response.sendRedirect("produtos.jsp");
	return;
}
%>
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
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	min-height: 100vh;
}

.form-container {
	background: white;
	border-radius: 10px;
	padding: 30px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
	margin-bottom: 20px;
}

.header {
	text-align: center;
	margin-bottom: 30px;
}

.header h2 {
	color: #333;
	margin: 0;
	font-size: 28px;
}

input[type="text"], input[type="email"], input[type="password"] {
	width: 100%;
	padding: 12px;
	margin: 8px 0 15px 0;
	border: 2px solid #ddd;
	border-radius: 6px;
	box-sizing: border-box;
	font-size: 16px;
	transition: border-color 0.3s;
}

input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus
	{
	border-color: #667eea;
	outline: none;
}

.checkbox-container {
	display: flex;
	align-items: center;
	margin: 15px 0;
}

.checkbox-container input[type="checkbox"] {
	margin-right: 8px;
	width: auto;
}

button {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	margin-right: 10px;
	font-size: 16px;
	font-weight: bold;
	transition: transform 0.2s;
	width: 100%;
	margin-bottom: 10px;
}

button:hover {
	transform: translateY(-2px);
}

button:disabled {
	background: #cccccc;
	cursor: not-allowed;
	transform: none;
}

.toggle-btn {
	background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
	color: #333;
	width: 100%;
}

.message {
	padding: 15px;
	margin: 15px 0;
	border-radius: 6px;
	text-align: center;
	font-weight: bold;
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

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
	color: #333;
}
</style>
</head>
<body>
	<div class="form-container">
		<div class="header">
			<h2 id="form-title">Entrar</h2>
		</div>

		<div id="message-container"></div>

		<form id="user-form">
			<div id="nome-field" class="form-group" style="display: none;">
				<label for="nome">Nome Completo:</label> <input type="text"
					id="nome" name="nome" placeholder="Digite seu nome completo">
			</div>

			<div class="form-group">
				<label for="email">Email:</label> <input type="email" id="email"
					name="email" required placeholder="Digite seu email">
			</div>

			<div class="form-group">
				<label for="senha">Senha:</label> <input type="password" id="senha"
					name="senha" required placeholder="Digite sua senha">
			</div>

			<div id="remember-field" class="checkbox-container">
				<input type="checkbox" id="lembrarMe" name="lembrarMe"> <label
					for="lembrarMe">Lembrar-me</label>
			</div>

			<button type="submit" id="submit-btn">Entrar</button>
			<button type="button" class="toggle-btn" onclick="toggleForm()">Não
				tem conta? Cadastre-se</button>
		</form>
	</div>

	<script>
        let isLoginMode = true;
        const contextPath = '<%=request.getContextPath()%>';
        
        // Carregar credenciais salvas ao inicializar
        window.addEventListener('load', function() {
            carregarCredenciaisSalvas();
            testarConectividade();
        });
        
        function carregarCredenciaisSalvas() {
            const emailSalvo = localStorage.getItem('email_salvo');
            const senhaSalva = localStorage.getItem('senha_salva');
            const lembrarMe = localStorage.getItem('lembrar_me') === 'true';
            
            if (lembrarMe && emailSalvo && senhaSalva) {
                document.getElementById('email').value = emailSalvo;
                document.getElementById('senha').value = senhaSalva;
                document.getElementById('lembrarMe').checked = true;
            }
        }
        
        function salvarCredenciais(email, senha, lembrar) {
            if (lembrar) {
                localStorage.setItem('email_salvo', email);
                localStorage.setItem('senha_salva', senha);
                localStorage.setItem('lembrar_me', 'true');
            } else {
                localStorage.removeItem('email_salvo');
                localStorage.removeItem('senha_salva');
                localStorage.removeItem('lembrar_me');
            }
        }
        
        function toggleForm() {
            const formTitle = document.getElementById('form-title');
            const nomeField = document.getElementById('nome-field');
            const submitBtn = document.getElementById('submit-btn');
            const toggleBtn = document.querySelector('.toggle-btn');
            const rememberField = document.getElementById('remember-field');
            
            if (isLoginMode) {
                // Mudar para modo cadastro
                formTitle.textContent = 'Criar Conta';
                nomeField.style.display = 'block';
                submitBtn.textContent = 'Cadastrar';
                toggleBtn.textContent = 'Já tem conta? Faça login';
                rememberField.style.display = 'none';
                document.getElementById('nome').required = true;
            } else {
                // Mudar para modo login
                formTitle.textContent = 'Entrar';
                nomeField.style.display = 'none';
                submitBtn.textContent = 'Entrar';
                toggleBtn.textContent = 'Não tem conta? Cadastre-se';
                rememberField.style.display = 'flex';
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
            const lembrarMe = document.getElementById('lembrarMe').checked;
            
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
                // Login
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
                    // Salvar credenciais se solicitado
                    salvarCredenciais(email, senha, lembrarMe);
                    
                    showMessage('Login realizado com sucesso! Redirecionando...', 'success');
                    
                    // Redirecionar para produtos após 1.5 segundos
                    setTimeout(() => {
                        window.location.href = contextPath + '/produtos.jsp';
                    }, 1500);
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
                    showMessage('Usuário cadastrado com sucesso! Agora você pode fazer login.', 'success');
                    document.getElementById('user-form').reset();
                    // Voltar para modo login após cadastro
                    setTimeout(() => {
                        if (!isLoginMode) toggleForm();
                    }, 2000);
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
    </script>
</body>
</html>
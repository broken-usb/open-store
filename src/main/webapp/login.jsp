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
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Ubuntu', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	max-width: 450px;
	margin: 0 auto;
	padding: 20px;
	background: linear-gradient(135deg, #2c2c2c 0%, #1a1a1a 50%, #0f0f0f 100%);
	min-height: 100vh;
	position: relative;
	overflow-x: hidden;
}

/* Efeito de círculos no fundo */
body::before {
	content: '';
	position: fixed;
	top: -50%;
	left: -50%;
	width: 200%;
	height: 200%;
	background: radial-gradient(circle at 20% 80%, rgba(255, 95, 21, 0.1) 0%,
		transparent 50%),
		radial-gradient(circle at 80% 20%, rgba(255, 95, 21, 0.05) 0%,
		transparent 50%),
		radial-gradient(circle at 40% 40%, rgba(255, 95, 21, 0.03) 0%,
		transparent 50%);
	z-index: -1;
	animation: float 20s ease-in-out infinite;
}

@
keyframes float { 0%, 100% {
	transform: translate(0, 0) rotate(0deg);
}

33
%
{
transform
:
translate(
30px
,
-30px
)
rotate(
120deg
);
}
66
%
{
transform
:
translate(
-20px
,
20px
)
rotate(
240deg
);
}
}
.form-container {
	background: linear-gradient(145deg, #333333 0%, #2a2a2a 100%);
	border-radius: 16px;
	padding: 40px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6), 0 2px 8px
		rgba(255, 95, 21, 0.1), inset 0 1px 0 rgba(255, 255, 255, 0.1);
	margin-bottom: 20px;
	border: 1px solid rgba(255, 95, 21, 0.2);
	backdrop-filter: blur(10px);
	position: relative;
	overflow: hidden;
}

.form-container::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
	background: linear-gradient(90deg, #ff5f15 0%, #ff8c42 50%, #ff5f15 100%);
	background-size: 200% 100%;
	animation: shimmer 3s ease-in-out infinite;
}

@
keyframes shimmer { 0%, 100% {
	background-position: 200% 0;
}

50
%
{
background-position
:
-200%
0;
}
}
.header {
	text-align: center;
	margin-bottom: 35px;
}

.header h2 {
	color: #ffffff;
	margin: 0;
	font-size: 32px;
	font-weight: 300;
	text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
	position: relative;
}

.header h2::after {
	content: '';
	position: absolute;
	bottom: -8px;
	left: 50%;
	transform: translateX(-50%);
	width: 60px;
	height: 2px;
	background: linear-gradient(90deg, #ff5f15, #ff8c42);
	border-radius: 1px;
}

input[type="text"], input[type="email"], input[type="password"] {
	width: 100%;
	padding: 16px 20px;
	margin: 8px 0 20px 0;
	border: 2px solid #444444;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 16px;
	background: #2a2a2a;
	color: #ffffff;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	font-family: inherit;
}

input[type="text"]::placeholder, input[type="email"]::placeholder, input[type="password"]::placeholder
	{
	color: #888888;
}

input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus
	{
	border-color: #ff5f15;
	outline: none;
	background: #333333;
	box-shadow: 0 0 0 3px rgba(255, 95, 21, 0.2), 0 4px 12px
		rgba(255, 95, 21, 0.1);
	transform: translateY(-1px);
}

.checkbox-container {
	display: flex;
	align-items: center;
	margin: 20px 0;
	color: #cccccc;
}

.checkbox-container input[type="checkbox"] {
	margin-right: 12px;
	width: 18px;
	height: 18px;
	accent-color: #ff5f15;
	cursor: pointer;
}

.checkbox-container label {
	cursor: pointer;
	user-select: none;
	transition: color 0.2s;
}

.checkbox-container:hover label {
	color: #ff8c42;
}

button {
	background: linear-gradient(135deg, #ff5f15 0%, #ff8c42 100%);
	color: #ffffff;
	padding: 16px 24px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	margin-right: 10px;
	font-size: 16px;
	font-weight: 500;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	width: 100%;
	margin-bottom: 15px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	position: relative;
	overflow: hidden;
	box-shadow: 0 4px 15px rgba(255, 95, 21, 0.3);
}

button::before {
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

button:hover {
	transform: translateY(-2px);
	box-shadow: 0 8px 25px rgba(255, 95, 21, 0.4);
	background: linear-gradient(135deg, #ff6b1a 0%, #ff9447 100%);
}

button:hover::before {
	left: 100%;
}

button:active {
	transform: translateY(0);
}

button:disabled {
	background: linear-gradient(135deg, #666666 0%, #555555 100%);
	cursor: not-allowed;
	transform: none;
	box-shadow: none;
	color: #999999;
}

.toggle-btn {
	background: linear-gradient(135deg, #444444 0%, #333333 100%);
	color: #ff8c42;
	border: 2px solid #ff5f15;
	font-weight: 400;
	text-transform: none;
	letter-spacing: normal;
}

.toggle-btn:hover {
	background: linear-gradient(135deg, #555555 0%, #444444 100%);
	color: #ffffff;
	border-color: #ff8c42;
	box-shadow: 0 8px 25px rgba(255, 95, 21, 0.2);
}

.message {
	padding: 16px 20px;
	margin: 20px 0;
	border-radius: 8px;
	text-align: center;
	font-weight: 500;
	border-left: 4px solid;
	animation: slideIn 0.3s ease-out;
}

@
keyframes slideIn {from { opacity:0;
	transform: translateY(-10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.success {
	background: linear-gradient(135deg, #1a4d3a 0%, #0f3a28 100%);
	color: #4ade80;
	border-left-color: #4ade80;
	box-shadow: 0 4px 12px rgba(74, 222, 128, 0.2);
}

.error {
	background: linear-gradient(135deg, #4d1a1a 0%, #3a0f0f 100%);
	color: #f87171;
	border-left-color: #f87171;
	box-shadow: 0 4px 12px rgba(248, 113, 113, 0.2);
}

.loading {
	background: linear-gradient(135deg, #1a3a4d 0%, #0f2833 100%);
	color: #38bdf8;
	border-left-color: #38bdf8;
	box-shadow: 0 4px 12px rgba(56, 189, 248, 0.2);
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
	color: #cccccc;
	text-transform: uppercase;
	font-size: 12px;
	letter-spacing: 1px;
}

/* Animações de entrada */
.form-container {
	animation: fadeInUp 0.6s ease-out;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* Responsividade aprimorada */
@media ( max-width : 480px) {
	body {
		padding: 10px;
	}
	.form-container {
		padding: 30px 25px;
		margin-bottom: 10px;
	}
	.header h2 {
		font-size: 28px;
	}
	input[type="text"], input[type="email"], input[type="password"] {
		padding: 14px 16px;
		font-size: 16px;
	}
	button {
		padding: 14px 20px;
		font-size: 15px;
	}
}

/* Melhorias de acessibilidade */
@media ( prefers-reduced-motion : reduce) {
	*, *::before, *::after {
		animation-duration: 0.01ms !important;
		animation-iteration-count: 1 !important;
		transition-duration: 0.01ms !important;
	}
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
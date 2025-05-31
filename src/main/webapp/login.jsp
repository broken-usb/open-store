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
	</div>

	<script>
        let isLoginMode = true;
        
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
            container.innerHTML = `<div class="message ${type}">${message}</div>`;
        }
        
        function clearMessages() {
            document.getElementById('message-container').innerHTML = '';
        }
        
        document.getElementById('user-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const senha = document.getElementById('senha').value;
            const nome = document.getElementById('nome').value;
            
            if (isLoginMode) {
                // Login - simular autenticação
                fetch('/usuarios')
                    .then(response => response.json())
                    .then(usuarios => {
                        const usuario = usuarios.find(u => u.email === email && u.senha === senha);
                        if (usuario) {
                            showMessage(`Bem-vindo, ${usuario.nome}!`, 'success');
                            setTimeout(() => {
                                document.querySelector('.form-container').style.display = 'none';
                                document.getElementById('usuarios-list').style.display = 'block';
                                listarUsuarios();
                            }, 1500);
                        } else {
                            showMessage('Email ou senha incorretos!', 'error');
                        }
                    })
                    .catch(error => {
                        showMessage('Erro ao fazer login!', 'error');
                        console.error('Error:', error);
                    });
            } else {
                // Cadastro
                const formData = new FormData();
                formData.append('nome', nome);
                formData.append('email', email);
                formData.append('senha', senha);
                
                fetch('/usuarios', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    } else {
                        throw new Error('Erro no cadastro');
                    }
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
                    showMessage('Erro ao cadastrar usuário!', 'error');
                    console.error('Error:', error);
                });
            }
        });
        
        function listarUsuarios() {
            fetch('/usuarios')
                .then(response => response.json())
                .then(usuarios => {
                    const container = document.getElementById('usuarios-container');
                    if (usuarios.length === 0) {
                        container.innerHTML = '<p>Nenhum usuário cadastrado.</p>';
                    } else {
                        let html = '<table border="1" style="width: 100%; border-collapse: collapse;">';
                        html += '<tr><th>ID</th><th>Nome</th><th>Email</th></tr>';
                        usuarios.forEach(usuario => {
                            html += `<tr>
                                <td>${usuario.id}</td>
                                <td>${usuario.nome}</td>
                                <td>${usuario.email}</td>
                            </tr>`;
                        });
                        html += '</table>';
                        container.innerHTML = html;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('usuarios-container').innerHTML = '<p>Erro ao carregar usuários.</p>';
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
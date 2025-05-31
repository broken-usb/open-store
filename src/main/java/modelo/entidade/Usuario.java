package modelo.entidade;

public class Usuario {
	private int id;
	private String nome;
	private String email;
	private String senha;

	// ID
	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	// NOME
	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getNome() {
		return this.nome;
	}

	// EMAIL
	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmail() {
		return this.email;
	}

	// SENHA
	public void setSenha(String senha) {
		this.senha = senha;
	}

	public String getSenha() {
		return this.senha;
	}
}
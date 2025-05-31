package modelo.entidade;

public class Produto {
	private int id;
	private String nome;
	private String descricao;
	private float preco;

	private Usuario usuario;

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

	// DESCRICAO
	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}

	public String getDescricao() {
		return this.descricao;
	}

	// PRECO
	public void setPreco(float preco) {
		this.preco = preco;
	}

	public float getPreco() {
		return this.preco;
	}

	// USUARIO
	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Usuario getUsuario() {
		return this.usuario;
	}

}

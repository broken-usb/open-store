package modelo.entidade;

import java.time.LocalDateTime;

public class Pedido {
	private int id;

	private Produto produto;
	private Usuario comprador;

	private LocalDateTime dataPedido;

	// ID
	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return this.id;
	}

	// PRODUTO
	public void setProduto(Produto produto) {
		this.produto = produto;
	}

	public Produto getProduto() {
		return this.produto;
	}

	// COMPRADOR
	public void setComprador(Usuario comprador) {
		this.comprador = comprador;
	}

	public Usuario getComprador() {
		return this.comprador;
	}

	// DATA DO PEDIDO
	public void setDataPedido(LocalDateTime dataPedido) {
		this.dataPedido = dataPedido;
	}

	public LocalDateTime getDataPedido() {
		return this.dataPedido;
	}
}
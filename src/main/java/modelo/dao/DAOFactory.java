package modelo.dao;

public class DAOFactory {

	public static UsuarioDAO getUsuarioDAO() {
		return new UsuarioDAO();
	}

	public static ProdutoDAO getProdutoDAO() {
		return new ProdutoDAO();
	}

	public static PedidoDAO getPedidoDAO() {
		return new PedidoDAO();
	}
}
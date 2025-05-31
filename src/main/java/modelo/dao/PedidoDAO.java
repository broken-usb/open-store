package modelo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import modelo.entidade.Pedido;
import modelo.entidade.Produto;
import modelo.entidade.Usuario;
import modelo.jdbc.ConnectionFactory;

public class PedidoDAO implements DAO<Pedido> {

	private ProdutoDAO produtoDAO = new ProdutoDAO();
	private UsuarioDAO usuarioDAO = new UsuarioDAO();

	@Override
	public int inserir(Pedido pedido) {
		String sql = "INSERT INTO pedidos (id_produto, id_comprador, data_pedido) VALUES (?, ?, ?)";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setInt(1, pedido.getProduto().getId());
			stmt.setInt(2, pedido.getComprador().getId());

			LocalDateTime dataPedido = pedido.getDataPedido();
			if (dataPedido == null) {
				dataPedido = LocalDateTime.now();
			}
			stmt.setTimestamp(3, Timestamp.valueOf(dataPedido));

			int linhasAfetadas = stmt.executeUpdate();

			if (linhasAfetadas > 0) {
				ResultSet rs = stmt.getGeneratedKeys();
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

			return -1;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}

	@Override
	public boolean atualizar(Pedido pedido) {
		String sql = "UPDATE pedidos SET id_produto = ?, id_comprador = ?, data_pedido = ? WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, pedido.getProduto().getId());
			stmt.setInt(2, pedido.getComprador().getId());
			stmt.setTimestamp(3, Timestamp.valueOf(pedido.getDataPedido()));
			stmt.setInt(4, pedido.getId());

			int linhasAfetadas = stmt.executeUpdate();
			return linhasAfetadas > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean remover(int id) {
		String sql = "DELETE FROM pedidos WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, id);

			int linhasAfetadas = stmt.executeUpdate();
			return linhasAfetadas > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public Pedido buscarPorId(int id) {
		String sql = "SELECT * FROM pedidos WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, id);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				int idProduto = rs.getInt("id_produto");
				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				int idComprador = rs.getInt("id_comprador");
				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				return pedido;
			}

			return null;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Pedido> listarTodos() {
		String sql = "SELECT * FROM pedidos";
		List<Pedido> pedidos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				int idProduto = rs.getInt("id_produto");
				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				int idComprador = rs.getInt("id_comprador");
				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				pedidos.add(pedido);
			}

			return pedidos;

		} catch (Exception e) {
			e.printStackTrace();
			return pedidos;
		}
	}

	public List<Pedido> listarPorComprador(int idComprador) {
		String sql = "SELECT * FROM pedidos WHERE id_comprador = ?";
		List<Pedido> pedidos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, idComprador);

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				int idProduto = rs.getInt("id_produto");
				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				pedidos.add(pedido);
			}

			return pedidos;

		} catch (Exception e) {
			e.printStackTrace();
			return pedidos;
		}
	}

	public List<Pedido> listarPorVendedor(int idVendedor) {
		List<Produto> produtosDoVendedor = produtoDAO.listarPorUsuario(idVendedor);

		if (produtosDoVendedor.isEmpty()) {
			return new ArrayList<>();
		}

		StringBuilder sql = new StringBuilder("SELECT * FROM pedidos WHERE id_produto IN (");
		for (int i = 0; i < produtosDoVendedor.size(); i++) {
			if (i > 0) {
				sql.append(", ");
			}
			sql.append("?");
		}
		sql.append(")");

		List<Pedido> pedidos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql.toString())) {
			for (int i = 0; i < produtosDoVendedor.size(); i++) {
				stmt.setInt(i + 1, produtosDoVendedor.get(i).getId());
			}

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				int idProduto = rs.getInt("id_produto");
				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				int idComprador = rs.getInt("id_comprador");
				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				pedidos.add(pedido);
			}

			return pedidos;

		} catch (Exception e) {
			e.printStackTrace();
			return pedidos;
		}
	}

	public List<Pedido> listarPorPeriodo(LocalDateTime dataInicio, LocalDateTime dataFim) {
		String sql = "SELECT * FROM pedidos WHERE data_pedido BETWEEN ? AND ?";
		List<Pedido> pedidos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setTimestamp(1, Timestamp.valueOf(dataInicio));
			stmt.setTimestamp(2, Timestamp.valueOf(dataFim));

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				int idProduto = rs.getInt("id_produto");
				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				int idComprador = rs.getInt("id_comprador");
				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				pedidos.add(pedido);
			}

			return pedidos;

		} catch (Exception e) {
			e.printStackTrace();
			return pedidos;
		}
	}

	public List<Pedido> listarPorProduto(int idProduto) {
		String sql = "SELECT * FROM pedidos WHERE id_produto = ?";
		List<Pedido> pedidos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, idProduto);

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Pedido pedido = new Pedido();
				pedido.setId(rs.getInt("id"));

				Produto produto = produtoDAO.buscarPorId(idProduto);
				pedido.setProduto(produto);

				int idComprador = rs.getInt("id_comprador");
				Usuario comprador = usuarioDAO.buscarPorId(idComprador);
				pedido.setComprador(comprador);

				pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());

				pedidos.add(pedido);
			}

			return pedidos;

		} catch (Exception e) {
			e.printStackTrace();
			return pedidos;
		}
	}
}
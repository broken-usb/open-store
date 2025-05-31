package modelo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import modelo.entidade.Produto;
import modelo.entidade.Usuario;
import modelo.jdbc.ConnectionFactory;

public class ProdutoDAO implements DAO<Produto> {

	private UsuarioDAO usuarioDAO = new UsuarioDAO();

	@Override
	public int inserir(Produto produto) {
		String sql = "INSERT INTO produtos (nome, descricao, preco, id_usuario) VALUES (?, ?, ?, ?)";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, produto.getNome());
			stmt.setString(2, produto.getDescricao());
			stmt.setFloat(3, produto.getPreco());
			stmt.setInt(4, produto.getUsuario().getId());

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
	public boolean atualizar(Produto produto) {
		String sql = "UPDATE produtos SET nome = ?, descricao = ?, preco = ?, id_usuario = ? WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setString(1, produto.getNome());
			stmt.setString(2, produto.getDescricao());
			stmt.setFloat(3, produto.getPreco());
			stmt.setInt(4, produto.getUsuario().getId());
			stmt.setInt(5, produto.getId());

			int linhasAfetadas = stmt.executeUpdate();
			return linhasAfetadas > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean remover(int id) {
		String sql = "DELETE FROM produtos WHERE id = ?";

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
	public Produto buscarPorId(int id) {
		String sql = "SELECT * FROM produtos WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, id);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Produto produto = new Produto();
				produto.setId(rs.getInt("id"));
				produto.setNome(rs.getString("nome"));
				produto.setDescricao(rs.getString("descricao"));
				produto.setPreco(rs.getFloat("preco"));

				int idUsuario = rs.getInt("id_usuario");
				Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
				produto.setUsuario(usuario);

				return produto;
			}

			return null;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Produto> listarTodos() {
		String sql = "SELECT * FROM produtos";
		List<Produto> produtos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Produto produto = new Produto();
				produto.setId(rs.getInt("id"));
				produto.setNome(rs.getString("nome"));
				produto.setDescricao(rs.getString("descricao"));
				produto.setPreco(rs.getFloat("preco"));

				int idUsuario = rs.getInt("id_usuario");
				Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
				produto.setUsuario(usuario);

				produtos.add(produto);
			}

			return produtos;

		} catch (Exception e) {
			e.printStackTrace();
			return produtos;
		}
	}

	public List<Produto> listarPorUsuario(int idUsuario) {
		String sql = "SELECT * FROM produtos WHERE id_usuario = ?";
		List<Produto> produtos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, idUsuario);

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produto produto = new Produto();
				produto.setId(rs.getInt("id"));
				produto.setNome(rs.getString("nome"));
				produto.setDescricao(rs.getString("descricao"));
				produto.setPreco(rs.getFloat("preco"));

				Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
				produto.setUsuario(usuario);

				produtos.add(produto);
			}

			return produtos;

		} catch (Exception e) {
			e.printStackTrace();
			return produtos;
		}
	}

	public List<Produto> buscarPorNome(String nome) {
		String sql = "SELECT * FROM produtos WHERE nome LIKE ?";
		List<Produto> produtos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setString(1, "%" + nome + "%");

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produto produto = new Produto();
				produto.setId(rs.getInt("id"));
				produto.setNome(rs.getString("nome"));
				produto.setDescricao(rs.getString("descricao"));
				produto.setPreco(rs.getFloat("preco"));

				int idUsuario = rs.getInt("id_usuario");
				Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
				produto.setUsuario(usuario);

				produtos.add(produto);
			}

			return produtos;

		} catch (Exception e) {
			e.printStackTrace();
			return produtos;
		}
	}

	public List<Produto> buscarPorFaixaDePreco(float precoMinimo, float precoMaximo) {
		String sql = "SELECT * FROM produtos WHERE preco BETWEEN ? AND ?";
		List<Produto> produtos = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setFloat(1, precoMinimo);
			stmt.setFloat(2, precoMaximo);

			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				Produto produto = new Produto();
				produto.setId(rs.getInt("id"));
				produto.setNome(rs.getString("nome"));
				produto.setDescricao(rs.getString("descricao"));
				produto.setPreco(rs.getFloat("preco"));

				int idUsuario = rs.getInt("id_usuario");
				Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
				produto.setUsuario(usuario);

				produtos.add(produto);
			}

			return produtos;

		} catch (Exception e) {
			e.printStackTrace();
			return produtos;
		}
	}
}
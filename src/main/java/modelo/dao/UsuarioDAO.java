package modelo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import modelo.entidade.Usuario;
import modelo.jdbc.ConnectionFactory;

public class UsuarioDAO implements DAO<Usuario> {

	@Override
	public int inserir(Usuario usuario) {
		String sql = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			stmt.setString(1, usuario.getNome());
			stmt.setString(2, usuario.getEmail());
			stmt.setString(3, usuario.getSenha());

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
	public boolean atualizar(Usuario usuario) {
		String sql = "UPDATE usuarios SET nome = ?, email = ?, senha = ? WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setString(1, usuario.getNome());
			stmt.setString(2, usuario.getEmail());
			stmt.setString(3, usuario.getSenha());
			stmt.setInt(4, usuario.getId());

			int linhasAfetadas = stmt.executeUpdate();
			return linhasAfetadas > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public boolean remover(int id) {
		String sql = "DELETE FROM usuarios WHERE id = ?";

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
	public Usuario buscarPorId(int id) {
		String sql = "SELECT * FROM usuarios WHERE id = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setInt(1, id);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(rs.getInt("id"));
				usuario.setNome(rs.getString("nome"));
				usuario.setEmail(rs.getString("email"));
				usuario.setSenha(rs.getString("senha"));

				return usuario;
			}

			return null;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Usuario> listarTodos() {
		String sql = "SELECT * FROM usuarios";
		List<Usuario> usuarios = new ArrayList<>();

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {
			while (rs.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(rs.getInt("id"));
				usuario.setNome(rs.getString("nome"));
				usuario.setEmail(rs.getString("email"));
				usuario.setSenha(rs.getString("senha"));

				usuarios.add(usuario);
			}

			return usuarios;

		} catch (Exception e) {
			e.printStackTrace();
			return usuarios;
		}
	}

	public Usuario buscarPorEmail(String email) {
		String sql = "SELECT * FROM usuarios WHERE email = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setString(1, email);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(rs.getInt("id"));
				usuario.setNome(rs.getString("nome"));
				usuario.setEmail(rs.getString("email"));
				usuario.setSenha(rs.getString("senha"));

				return usuario;
			}

			return null;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public Usuario autenticar(String email, String senha) {
		String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";

		try (Connection conexao = ConnectionFactory.getConnection();
				PreparedStatement stmt = conexao.prepareStatement(sql)) {
			stmt.setString(1, email);
			stmt.setString(2, senha);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				Usuario usuario = new Usuario();
				usuario.setId(rs.getInt("id"));
				usuario.setNome(rs.getString("nome"));
				usuario.setEmail(rs.getString("email"));
				usuario.setSenha(rs.getString("senha"));

				return usuario;
			}

			return null;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
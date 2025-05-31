package modelo.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionFactory {
	public static Connection getConnection() {
		String stringJDBC = "jdbc:mysql://localhost:3306/open_store?useSSL=false&serverTimezone=UTC";
		String usuario = "root";
		String senha = "root"; // coloque a sua senha correta aqui

		Connection conexao = null;

		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); // driver atualizado
			conexao = DriverManager.getConnection(stringJDBC, usuario, senha);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return conexao;
	}
}
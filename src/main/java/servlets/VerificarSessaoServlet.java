package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;

import modelo.entidade.Usuario;

@WebServlet("/verificar-sessao")
public class VerificarSessaoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Gson gson;

	public VerificarSessaoServlet() {
		super();
		gson = new Gson();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		try {
			HttpSession session = request.getSession(false);

			if (session != null && session.getAttribute("usuario") != null) {
				Usuario usuario = (Usuario) session.getAttribute("usuario");

				// Verificar se a sessão ainda é válida
				if (usuario != null && usuario.getId() > 0) {
					// Não retornar a senha por segurança
					usuario.setSenha(null);
					response.setStatus(HttpServletResponse.SC_OK);
					out.print(gson.toJson(usuario));
				} else {
					response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
					out.print("{\"erro\":\"Sessão inválida\"}");
				}
			} else {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				out.print("{\"erro\":\"Usuário não autenticado\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"erro\":\"Erro interno do servidor\"}");
		}
	}
}
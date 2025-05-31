package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import com.google.gson.Gson;

import modelo.dao.UsuarioDAO;
import modelo.entidade.Usuario;

@WebServlet("/usuarios/*")
public class UsuarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UsuarioDAO usuarioDAO;
	private Gson gson;

	public UsuarioServlet() {
		super();
		usuarioDAO = new UsuarioDAO();
		gson = new Gson();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		String pathInfo = request.getPathInfo();

		try {
			if (pathInfo == null || pathInfo.equals("/")) {
				// Listar todos os usuários
				List<Usuario> usuarios = usuarioDAO.listarTodos();
				out.print(gson.toJson(usuarios));
			} else {
				// Buscar usuário por ID
				String idStr = pathInfo.substring(1);
				int id = Integer.parseInt(idStr);
				Usuario usuario = usuarioDAO.buscarPorId(id);

				if (usuario != null) {
					out.print(gson.toJson(usuario));
				} else {
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					out.print("{\"erro\":\"Usuário não encontrado\"}");
				}
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"erro\":\"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"erro\":\"Erro interno do servidor\"}");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		try {
			// Criar novo usuário
			String nome = request.getParameter("nome");
			String email = request.getParameter("email");
			String senha = request.getParameter("senha");

			if (nome == null || email == null || senha == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"erro\":\"Todos os campos são obrigatórios\"}");
				return;
			}

			Usuario usuario = new Usuario();
			usuario.setNome(nome);
			usuario.setEmail(email);
			usuario.setSenha(senha);

			int id = usuarioDAO.inserir(usuario);

			if (id > 0) {
				usuario.setId(id);
				response.setStatus(HttpServletResponse.SC_CREATED);
				out.print(gson.toJson(usuario));
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				out.print("{\"erro\":\"Erro ao criar usuário\"}");
			}
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"erro\":\"Erro interno do servidor\"}");
		}
	}

	@Override
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		String pathInfo = request.getPathInfo();

		try {
			if (pathInfo == null || pathInfo.equals("/")) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"erro\":\"ID do usuário é obrigatório\"}");
				return;
			}

			// Atualizar usuário
			String idStr = pathInfo.substring(1);
			int id = Integer.parseInt(idStr);

			String nome = request.getParameter("nome");
			String email = request.getParameter("email");
			String senha = request.getParameter("senha");

			if (nome == null || email == null || senha == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"erro\":\"Todos os campos são obrigatórios\"}");
				return;
			}

			Usuario usuario = new Usuario();
			usuario.setId(id);
			usuario.setNome(nome);
			usuario.setEmail(email);
			usuario.setSenha(senha);

			boolean sucesso = usuarioDAO.atualizar(usuario);

			if (sucesso) {
				out.print(gson.toJson(usuario));
			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				out.print("{\"erro\":\"Usuário não encontrado ou erro na atualização\"}");
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"erro\":\"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"erro\":\"Erro interno do servidor\"}");
		}
	}

	@Override
	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		String pathInfo = request.getPathInfo();

		try {
			if (pathInfo == null || pathInfo.equals("/")) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				out.print("{\"erro\":\"ID do usuário é obrigatório\"}");
				return;
			}

			// Deletar usuário
			String idStr = pathInfo.substring(1);
			int id = Integer.parseInt(idStr);

			boolean sucesso = usuarioDAO.remover(id);

			if (sucesso) {
				out.print("{\"mensagem\":\"Usuário removido com sucesso\"}");
			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				out.print("{\"erro\":\"Usuário não encontrado\"}");
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.print("{\"erro\":\"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"erro\":\"Erro interno do servidor\"}");
		}
	}
}
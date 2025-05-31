package controle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import modelo.dao.UsuarioDAO;
import modelo.entidade.Usuario;

/**
 * Servlet implementation class UsuarioServlet
 */
@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UsuarioDAO usuarioDAO;

	public UsuarioServlet() {
		super();
		this.usuarioDAO = new UsuarioDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String acao = request.getParameter("acao");

		if (acao == null) {
			listarUsuarios(request, response);
		} else {
			switch (acao) {
			case "listar":
				listarUsuarios(request, response);
				break;
			case "buscar":
				buscarUsuario(request, response);
				break;
			case "logout":
				logout(request, response);
				break;
			default:
				listarUsuarios(request, response);
				break;
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String acao = request.getParameter("acao");

		if (acao == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação não especificada");
			return;
		}

		switch (acao) {
		case "inserir":
			inserirUsuario(request, response);
			break;
		case "atualizar":
			atualizarUsuario(request, response);
			break;
		case "remover":
			removerUsuario(request, response);
			break;
		case "autenticar":
			autenticarUsuario(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
			break;
		}
	}

	private void inserirUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		if (nome == null || email == null || senha == null || nome.trim().isEmpty() || email.trim().isEmpty()
				|| senha.trim().isEmpty()) {
			enviarResposta(response, "erro", "Todos os campos são obrigatórios");
			return;
		}

		// Verificar se email já existe
		Usuario usuarioExistente = usuarioDAO.buscarPorEmail(email);
		if (usuarioExistente != null) {
			enviarResposta(response, "erro", "Email já está em uso");
			return;
		}

		Usuario usuario = new Usuario();
		usuario.setNome(nome.trim());
		usuario.setEmail(email.trim().toLowerCase());
		usuario.setSenha(senha);

		int id = usuarioDAO.inserir(usuario);

		if (id > 0) {
			enviarResposta(response, "sucesso", "Usuário cadastrado com sucesso. ID: " + id);
		} else {
			enviarResposta(response, "erro", "Erro ao cadastrar usuário");
		}
	}

	private void atualizarUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");
		String nome = request.getParameter("nome");
		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		if (idStr == null || nome == null || email == null || senha == null || idStr.trim().isEmpty()
				|| nome.trim().isEmpty() || email.trim().isEmpty() || senha.trim().isEmpty()) {
			enviarResposta(response, "erro", "Todos os campos são obrigatórios");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);

			// Verificar se usuário existe
			Usuario usuarioExistente = usuarioDAO.buscarPorId(id);
			if (usuarioExistente == null) {
				enviarResposta(response, "erro", "Usuário não encontrado");
				return;
			}

			// Verificar se o novo email já está em uso por outro usuário
			Usuario usuarioComEmail = usuarioDAO.buscarPorEmail(email);
			if (usuarioComEmail != null && usuarioComEmail.getId() != id) {
				enviarResposta(response, "erro", "Email já está em uso por outro usuário");
				return;
			}

			Usuario usuario = new Usuario();
			usuario.setId(id);
			usuario.setNome(nome.trim());
			usuario.setEmail(email.trim().toLowerCase());
			usuario.setSenha(senha);

			boolean sucesso = usuarioDAO.atualizar(usuario);

			if (sucesso) {
				enviarResposta(response, "sucesso", "Usuário atualizado com sucesso");
			} else {
				enviarResposta(response, "erro", "Erro ao atualizar usuário");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID inválido");
		}
	}

	private void removerUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");

		if (idStr == null || idStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "ID é obrigatório");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);

			// Verificar se usuário existe
			Usuario usuario = usuarioDAO.buscarPorId(id);
			if (usuario == null) {
				enviarResposta(response, "erro", "Usuário não encontrado");
				return;
			}

			boolean sucesso = usuarioDAO.remover(id);

			if (sucesso) {
				enviarResposta(response, "sucesso", "Usuário removido com sucesso");
			} else {
				enviarResposta(response, "erro", "Erro ao remover usuário");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID inválido");
		}
	}

	private void buscarUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");
		String email = request.getParameter("email");

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		try {
			Usuario usuario = null;

			if (idStr != null && !idStr.trim().isEmpty()) {
				int id = Integer.parseInt(idStr);
				usuario = usuarioDAO.buscarPorId(id);
			} else if (email != null && !email.trim().isEmpty()) {
				usuario = usuarioDAO.buscarPorEmail(email.trim().toLowerCase());
			} else {
				out.println("{\"status\":\"erro\",\"mensagem\":\"ID ou email é obrigatório\"}");
				return;
			}

			if (usuario != null) {
				out.println("{\"status\":\"sucesso\",\"usuario\":{" + "\"id\":" + usuario.getId() + "," + "\"nome\":\""
						+ usuario.getNome() + "\"," + "\"email\":\"" + usuario.getEmail() + "\"" + "}}");
			} else {
				out.println("{\"status\":\"erro\",\"mensagem\":\"Usuário não encontrado\"}");
			}

		} catch (NumberFormatException e) {
			out.println("{\"status\":\"erro\",\"mensagem\":\"ID inválido\"}");
		}
	}

	private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Usuario> usuarios = usuarioDAO.listarTodos();

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		out.println("{\"status\":\"sucesso\",\"usuarios\":[");

		for (int i = 0; i < usuarios.size(); i++) {
			Usuario usuario = usuarios.get(i);
			out.print("{" + "\"id\":" + usuario.getId() + "," + "\"nome\":\"" + usuario.getNome() + "\","
					+ "\"email\":\"" + usuario.getEmail() + "\"" + "}");

			if (i < usuarios.size() - 1) {
				out.print(",");
			}
		}

		out.println("]}");
	}

	private void autenticarUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String senha = request.getParameter("senha");

		if (email == null || senha == null || email.trim().isEmpty() || senha.trim().isEmpty()) {
			enviarResposta(response, "erro", "Email e senha são obrigatórios");
			return;
		}

		Usuario usuario = usuarioDAO.autenticar(email.trim().toLowerCase(), senha);

		if (usuario != null) {
			// Criar sessão
			HttpSession session = request.getSession();
			session.setAttribute("usuarioLogado", usuario);
			session.setAttribute("usuarioId", usuario.getId());
			session.setAttribute("usuarioNome", usuario.getNome());
			session.setAttribute("usuarioEmail", usuario.getEmail());

			enviarResposta(response, "sucesso", "Login realizado com sucesso");
		} else {
			enviarResposta(response, "erro", "Email ou senha inválidos");
		}
	}

	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}

		enviarResposta(response, "sucesso", "Logout realizado com sucesso");
	}

	private void enviarResposta(HttpServletResponse response, String status, String mensagem) throws IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.println("{\"status\":\"" + status + "\",\"mensagem\":\"" + mensagem + "\"}");
	}
}
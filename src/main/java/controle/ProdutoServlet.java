package controle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import modelo.dao.ProdutoDAO;
import modelo.dao.UsuarioDAO;
import modelo.entidade.Produto;
import modelo.entidade.Usuario;

/**
 * Servlet implementation class ProdutoServlet
 */
@WebServlet("/ProdutoServlet")
public class ProdutoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProdutoDAO produtoDAO;
	private UsuarioDAO usuarioDAO;

	public ProdutoServlet() {
		super();
		this.produtoDAO = new ProdutoDAO();
		this.usuarioDAO = new UsuarioDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String acao = request.getParameter("acao");

		if (acao == null) {
			listarProdutos(request, response);
		} else {
			switch (acao) {
			case "listar":
				listarProdutos(request, response);
				break;
			case "buscar":
				buscarProduto(request, response);
				break;
			case "listarPorUsuario":
				listarProdutosPorUsuario(request, response);
				break;
			case "buscarPorNome":
				buscarProdutosPorNome(request, response);
				break;
			case "buscarPorPreco":
				buscarProdutosPorPreco(request, response);
				break;
			default:
				listarProdutos(request, response);
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
			inserirProduto(request, response);
			break;
		case "atualizar":
			atualizarProduto(request, response);
			break;
		case "remover":
			removerProduto(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
			break;
		}
	}

	private void inserirProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String nome = request.getParameter("nome");
		String descricao = request.getParameter("descricao");
		String precoStr = request.getParameter("preco");
		String idUsuarioStr = request.getParameter("idUsuario");

		if (nome == null || descricao == null || precoStr == null || idUsuarioStr == null || nome.trim().isEmpty()
				|| precoStr.trim().isEmpty() || idUsuarioStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "Nome, preço e ID do usuário são obrigatórios");
			return;
		}

		try {
			float preco = Float.parseFloat(precoStr);
			int idUsuario = Integer.parseInt(idUsuarioStr);

			if (preco <= 0) {
				enviarResposta(response, "erro", "Preço deve ser maior que zero");
				return;
			}

			// Verificar se usuário existe
			Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
			if (usuario == null) {
				enviarResposta(response, "erro", "Usuário não encontrado");
				return;
			}

			Produto produto = new Produto();
			produto.setNome(nome.trim());
			produto.setDescricao(descricao.trim());
			produto.setPreco(preco);
			produto.setUsuario(usuario);

			int id = produtoDAO.inserir(produto);

			if (id > 0) {
				enviarResposta(response, "sucesso", "Produto cadastrado com sucesso. ID: " + id);
			} else {
				enviarResposta(response, "erro", "Erro ao cadastrar produto");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "Preço ou ID do usuário inválido");
		}
	}

	private void atualizarProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");
		String nome = request.getParameter("nome");
		String descricao = request.getParameter("descricao");
		String precoStr = request.getParameter("preco");
		String idUsuarioStr = request.getParameter("idUsuario");

		if (idStr == null || nome == null || descricao == null || precoStr == null || idUsuarioStr == null
				|| idStr.trim().isEmpty() || nome.trim().isEmpty() || precoStr.trim().isEmpty()
				|| idUsuarioStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "Todos os campos são obrigatórios");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);
			float preco = Float.parseFloat(precoStr);
			int idUsuario = Integer.parseInt(idUsuarioStr);

			if (preco <= 0) {
				enviarResposta(response, "erro", "Preço deve ser maior que zero");
				return;
			}

			// Verificar se produto existe
			Produto produtoExistente = produtoDAO.buscarPorId(id);
			if (produtoExistente == null) {
				enviarResposta(response, "erro", "Produto não encontrado");
				return;
			}

			// Verificar se usuário existe
			Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
			if (usuario == null) {
				enviarResposta(response, "erro", "Usuário não encontrado");
				return;
			}

			Produto produto = new Produto();
			produto.setId(id);
			produto.setNome(nome.trim());
			produto.setDescricao(descricao.trim());
			produto.setPreco(preco);
			produto.setUsuario(usuario);

			boolean sucesso = produtoDAO.atualizar(produto);

			if (sucesso) {
				enviarResposta(response, "sucesso", "Produto atualizado com sucesso");
			} else {
				enviarResposta(response, "erro", "Erro ao atualizar produto");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID, preço ou ID do usuário inválido");
		}
	}

	private void removerProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");

		if (idStr == null || idStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "ID é obrigatório");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);

			// Verificar se produto existe
			Produto produto = produtoDAO.buscarPorId(id);
			if (produto == null) {
				enviarResposta(response, "erro", "Produto não encontrado");
				return;
			}

			boolean sucesso = produtoDAO.remover(id);

			if (sucesso) {
				enviarResposta(response, "sucesso", "Produto removido com sucesso");
			} else {
				enviarResposta(response, "erro", "Erro ao remover produto");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID inválido");
		}
	}

	private void buscarProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");

		if (idStr == null || idStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "ID é obrigatório");
			return;
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		try {
			int id = Integer.parseInt(idStr);
			Produto produto = produtoDAO.buscarPorId(id);

			if (produto != null) {
				out.println("{\"status\":\"sucesso\",\"produto\":{" + "\"id\":" + produto.getId() + "," + "\"nome\":\""
						+ produto.getNome() + "\"," + "\"descricao\":\"" + produto.getDescricao() + "\"," + "\"preco\":"
						+ produto.getPreco() + "," + "\"usuario\":{" + "\"id\":" + produto.getUsuario().getId() + ","
						+ "\"nome\":\"" + produto.getUsuario().getNome() + "\"," + "\"email\":\""
						+ produto.getUsuario().getEmail() + "\"" + "}" + "}}");
			} else {
				out.println("{\"status\":\"erro\",\"mensagem\":\"Produto não encontrado\"}");
			}

		} catch (NumberFormatException e) {
			out.println("{\"status\":\"erro\",\"mensagem\":\"ID inválido\"}");
		}
	}

	private void listarProdutos(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Produto> produtos = produtoDAO.listarTodos();

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		out.println("{\"status\":\"sucesso\",\"produtos\":[");

		for (int i = 0; i < produtos.size(); i++) {
			Produto produto = produtos.get(i);
			out.print("{" + "\"id\":" + produto.getId() + "," + "\"nome\":\"" + produto.getNome() + "\","
					+ "\"descricao\":\"" + produto.getDescricao() + "\"," + "\"preco\":" + produto.getPreco() + ","
					+ "\"usuario\":{" + "\"id\":" + produto.getUsuario().getId() + "," + "\"nome\":\""
					+ produto.getUsuario().getNome() + "\"," + "\"email\":\"" + produto.getUsuario().getEmail() + "\""
					+ "}" + "}");

			if (i < produtos.size() - 1) {
				out.print(",");
			}
		}

		out.println("]}");
	}

	private void listarProdutosPorUsuario(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idUsuarioStr = request.getParameter("idUsuario");

		if (idUsuarioStr == null || idUsuarioStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "ID do usuário é obrigatório");
			return;
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		try {
			int idUsuario = Integer.parseInt(idUsuarioStr);
			List<Produto> produtos = produtoDAO.listarPorUsuario(idUsuario);

			out.println("{\"status\":\"sucesso\",\"produtos\":[");

			for (int i = 0; i < produtos.size(); i++) {
				Produto produto = produtos.get(i);
				out.print("{" + "\"id\":" + produto.getId() + "," + "\"nome\":\"" + produto.getNome() + "\","
						+ "\"descricao\":\"" + produto.getDescricao() + "\"," + "\"preco\":" + produto.getPreco() + ","
						+ "\"usuario\":{" + "\"id\":" + produto.getUsuario().getId() + "," + "\"nome\":\""
						+ produto.getUsuario().getNome() + "\"," + "\"email\":\"" + produto.getUsuario().getEmail()
						+ "\"" + "}" + "}");

				if (i < produtos.size() - 1) {
					out.print(",");
				}
			}

			out.println("]}");

		} catch (NumberFormatException e) {
			out.println("{\"status\":\"erro\",\"mensagem\":\"ID do usuário inválido\"}");
		}
	}

	private void buscarProdutosPorNome(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String nome = request.getParameter("nome");

		if (nome == null || nome.trim().isEmpty()) {
			enviarResposta(response, "erro", "Nome é obrigatório");
			return;
		}

		List<Produto> produtos = produtoDAO.buscarPorNome(nome.trim());

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		out.println("{\"status\":\"sucesso\",\"produtos\":[");

		for (int i = 0; i < produtos.size(); i++) {
			Produto produto = produtos.get(i);
			out.print("{" + "\"id\":" + produto.getId() + "," + "\"nome\":\"" + produto.getNome() + "\","
					+ "\"descricao\":\"" + produto.getDescricao() + "\"," + "\"preco\":" + produto.getPreco() + ","
					+ "\"usuario\":{" + "\"id\":" + produto.getUsuario().getId() + "," + "\"nome\":\""
					+ produto.getUsuario().getNome() + "\"," + "\"email\":\"" + produto.getUsuario().getEmail() + "\""
					+ "}" + "}");

			if (i < produtos.size() - 1) {
				out.print(",");
			}
		}

		out.println("]}");
	}

	private void buscarProdutosPorPreco(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String precoMinimoStr = request.getParameter("precoMinimo");
		String precoMaximoStr = request.getParameter("precoMaximo");

		if (precoMinimoStr == null || precoMaximoStr == null || precoMinimoStr.trim().isEmpty()
				|| precoMaximoStr.trim().isEmpty()) {
			enviarResposta(response, "erro", "Preço mínimo e máximo são obrigatórios");
			return;
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		try {
			float precoMinimo = Float.parseFloat(precoMinimoStr);
			float precoMaximo = Float.parseFloat(precoMaximoStr);

			if (precoMinimo < 0 || precoMaximo < 0 || precoMinimo > precoMaximo) {
				out.println("{\"status\":\"erro\",\"mensagem\":\"Faixa de preço inválida\"}");
				return;
			}

			List<Produto> produtos = produtoDAO.buscarPorFaixaDePreco(precoMinimo, precoMaximo);

			out.println("{\"status\":\"sucesso\",\"produtos\":[");

			for (int i = 0; i < produtos.size(); i++) {
				Produto produto = produtos.get(i);
				out.print("{" + "\"id\":" + produto.getId() + "," + "\"nome\":\"" + produto.getNome() + "\","
						+ "\"descricao\":\"" + produto.getDescricao() + "\"," + "\"preco\":" + produto.getPreco() + ","
						+ "\"usuario\":{" + "\"id\":" + produto.getUsuario().getId() + "," + "\"nome\":\""
						+ produto.getUsuario().getNome() + "\"," + "\"email\":\"" + produto.getUsuario().getEmail()
						+ "\"" + "}" + "}");

				if (i < produtos.size() - 1) {
					out.print(",");
				}
			}

			out.println("]}");

		} catch (NumberFormatException e) {
			out.println("{\"status\":\"erro\",\"mensagem\":\"Preços inválidos\"}");
		}
	}

	private void enviarResposta(HttpServletResponse response, String status, String mensagem) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();
		out.println("{\"status\":\"" + status + "\",\"mensagem\":\"" + mensagem + "\"}");
	}
}
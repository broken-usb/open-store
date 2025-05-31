package controle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import modelo.dao.PedidoDAO;
import modelo.dao.ProdutoDAO;
import modelo.dao.UsuarioDAO;
import modelo.entidade.Pedido;
import modelo.entidade.Produto;
import modelo.entidade.Usuario;

/**
 * Servlet implementation class PedidoServlet
 */
@WebServlet("/PedidoServlet")
public class PedidoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private PedidoDAO pedidoDAO;
	private ProdutoDAO produtoDAO;
	private UsuarioDAO usuarioDAO;
	private SimpleDateFormat dateFormat;

	public PedidoServlet() {
		super();
		this.pedidoDAO = new PedidoDAO();
		this.produtoDAO = new ProdutoDAO();
		this.usuarioDAO = new UsuarioDAO();
		this.dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String acao = request.getParameter("acao");

		try {
			if (acao == null || "listar".equals(acao)) {
				listarPedidos(request, response);
			} else {
				switch (acao) {
				case "buscar":
					buscarPedido(request, response);
					break;
				case "listarPorComprador":
					listarPedidosPorComprador(request, response);
					break;
				case "listarPorVendedor":
					listarPedidosPorVendedor(request, response);
					break;
				case "listarPorProduto":
					listarPedidosPorProduto(request, response);
					break;
				default:
					enviarErro(response, HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			enviarErro(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro interno do servidor");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String acao = request.getParameter("acao");

		if (acao == null) {
			enviarErro(response, HttpServletResponse.SC_BAD_REQUEST, "Ação não especificada");
			return;
		}

		try {
			switch (acao) {
			case "inserir":
				inserirPedido(request, response);
				break;
			case "remover":
				removerPedido(request, response);
				break;
			default:
				enviarErro(response, HttpServletResponse.SC_BAD_REQUEST, "Ação inválida");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			enviarErro(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro interno do servidor");
		}
	}

	private void inserirPedido(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idProdutoStr = request.getParameter("idProduto");
		String idCompradorStr = request.getParameter("idComprador");

		if (isNullOrEmpty(idProdutoStr) || isNullOrEmpty(idCompradorStr)) {
			enviarResposta(response, "erro", "ID do produto e ID do comprador são obrigatórios");
			return;
		}

		try {
			int idProduto = Integer.parseInt(idProdutoStr);
			int idComprador = Integer.parseInt(idCompradorStr);

			// Verificar se produto existe
			Produto produto = produtoDAO.buscarPorId(idProduto);
			if (produto == null) {
				enviarResposta(response, "erro", "Produto não encontrado");
				return;
			}

			// Verificar se comprador existe
			Usuario comprador = usuarioDAO.buscarPorId(idComprador);
			if (comprador == null) {
				enviarResposta(response, "erro", "Comprador não encontrado");
				return;
			}

			// Verificar se o comprador não é o próprio vendedor do produto
			if (produto.getUsuario().getId() == idComprador) {
				enviarResposta(response, "erro", "Você não pode comprar seu próprio produto");
				return;
			}

			Pedido pedido = new Pedido();
			pedido.setProduto(produto);
			pedido.setComprador(comprador);

			int id = pedidoDAO.inserir(pedido);

			if (id > 0) {
				enviarResposta(response, "sucesso", "Pedido realizado com sucesso. ID: " + id);
			} else {
				enviarResposta(response, "erro", "Erro ao realizar pedido");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID do produto ou comprador inválido");
		}
	}

	private void removerPedido(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");

		if (isNullOrEmpty(idStr)) {
			enviarResposta(response, "erro", "ID é obrigatório");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);

			// Verificar se pedido existe
			Pedido pedido = pedidoDAO.buscarPorId(id);
			if (pedido == null) {
				enviarResposta(response, "erro", "Pedido não encontrado");
				return;
			}

			boolean sucesso = pedidoDAO.remover(id);

			if (sucesso) {
				enviarResposta(response, "sucesso", "Pedido removido com sucesso");
			} else {
				enviarResposta(response, "erro", "Erro ao remover pedido");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID inválido");
		}
	}

	private void buscarPedido(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idStr = request.getParameter("id");

		if (isNullOrEmpty(idStr)) {
			enviarResposta(response, "erro", "ID é obrigatório");
			return;
		}

		try {
			int id = Integer.parseInt(idStr);
			Pedido pedido = pedidoDAO.buscarPorId(id);

			if (pedido != null) {
				enviarPedidoJson(response, "sucesso", pedido);
			} else {
				enviarResposta(response, "erro", "Pedido não encontrado");
			}

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID inválido");
		}
	}

	private void listarPedidos(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Pedido> pedidos = pedidoDAO.listarTodos();
		enviarListaPedidosJson(response, "sucesso", pedidos);
	}

	private void listarPedidosPorComprador(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idCompradorStr = request.getParameter("idComprador");

		if (isNullOrEmpty(idCompradorStr)) {
			enviarResposta(response, "erro", "ID do comprador é obrigatório");
			return;
		}

		try {
			int idComprador = Integer.parseInt(idCompradorStr);
			List<Pedido> pedidos = pedidoDAO.listarPorComprador(idComprador);
			enviarListaPedidosJson(response, "sucesso", pedidos);

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID do comprador inválido");
		}
	}

	private void listarPedidosPorVendedor(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idVendedorStr = request.getParameter("idVendedor");

		if (isNullOrEmpty(idVendedorStr)) {
			enviarResposta(response, "erro", "ID do vendedor é obrigatório");
			return;
		}

		try {
			int idVendedor = Integer.parseInt(idVendedorStr);
			List<Pedido> pedidos = pedidoDAO.listarPorVendedor(idVendedor);
			enviarListaPedidosJson(response, "sucesso", pedidos);

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID do vendedor inválido");
		}
	}

	private void listarPedidosPorProduto(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String idProdutoStr = request.getParameter("idProduto");

		if (isNullOrEmpty(idProdutoStr)) {
			enviarResposta(response, "erro", "ID do produto é obrigatório");
			return;
		}

		try {
			int idProduto = Integer.parseInt(idProdutoStr);
			List<Pedido> pedidos = pedidoDAO.listarPorProduto(idProduto);
			enviarListaPedidosJson(response, "sucesso", pedidos);

		} catch (NumberFormatException e) {
			enviarResposta(response, "erro", "ID do produto inválido");
		}
	}

	// Métodos utilitários
	private boolean isNullOrEmpty(String str) {
		return str == null || str.trim().isEmpty();
	}

	private void enviarResposta(HttpServletResponse response, String status, String mensagem) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try (PrintWriter out = response.getWriter()) {
			out.printf("{\"status\":\"%s\",\"mensagem\":\"%s\"}", escapeJson(status), escapeJson(mensagem));
		}
	}

	private void enviarErro(HttpServletResponse response, int statusCode, String mensagem) throws IOException {
		response.setStatus(statusCode);
		enviarResposta(response, "erro", mensagem);
	}

	private void enviarPedidoJson(HttpServletResponse response, String status, Pedido pedido) throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try (PrintWriter out = response.getWriter()) {
			out.printf("{\"status\":\"%s\",\"pedido\":%s}", escapeJson(status), pedidoToJson(pedido));
		}
	}

	private void enviarListaPedidosJson(HttpServletResponse response, String status, List<Pedido> pedidos)
			throws IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try (PrintWriter out = response.getWriter()) {
			out.printf("{\"status\":\"%s\",\"pedidos\":[", escapeJson(status));

			for (int i = 0; i < pedidos.size(); i++) {
				if (i > 0) {
					out.print(",");
				}
				out.print(pedidoToJson(pedidos.get(i)));
			}

			out.print("]}");
		}
	}

	private String pedidoToJson(Pedido pedido) {
		StringBuilder json = new StringBuilder();
		json.append("{");
		json.append("\"id\":").append(pedido.getId()).append(",");
		json.append("\"dataPedido\":\"").append(dateFormat.format(pedido.getDataPedido())).append("\",");

		// Produto
		json.append("\"produto\":{");
		json.append("\"id\":").append(pedido.getProduto().getId()).append(",");
		json.append("\"nome\":\"").append(escapeJson(pedido.getProduto().getNome())).append("\",");
		json.append("\"descricao\":\"").append(escapeJson(pedido.getProduto().getDescricao())).append("\",");
		json.append("\"preco\":").append(pedido.getProduto().getPreco()).append(",");

		// Vendedor (usuário do produto)
		json.append("\"usuario\":{");
		json.append("\"id\":").append(pedido.getProduto().getUsuario().getId()).append(",");
		json.append("\"nome\":\"").append(escapeJson(pedido.getProduto().getUsuario().getNome())).append("\",");
		json.append("\"email\":\"").append(escapeJson(pedido.getProduto().getUsuario().getEmail())).append("\"");
		json.append("}");
		json.append("},");

		// Comprador
		json.append("\"comprador\":{");
		json.append("\"id\":").append(pedido.getComprador().getId()).append(",");
		json.append("\"nome\":\"").append(escapeJson(pedido.getComprador().getNome())).append("\",");
		json.append("\"email\":\"").append(escapeJson(pedido.getComprador().getEmail())).append("\"");
		json.append("}");

		json.append("}");
		return json.toString();
	}

	private String escapeJson(String str) {
		if (str == null) {
			return "";
		}
		return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t",
				"\\t");
	}
}
package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.BufferedReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;

import modelo.dao.PedidoDAO;
import modelo.dao.ProdutoDAO;
import modelo.dao.UsuarioDAO;
import modelo.entidade.Pedido;
import modelo.entidade.Produto;
import modelo.entidade.Usuario;

@WebServlet("/pedidos/*")
public class PedidoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PedidoDAO pedidoDAO;
	private ProdutoDAO produtoDAO;
	private UsuarioDAO usuarioDAO;
	private Gson gson;

	@Override
	public void init() throws ServletException {
		pedidoDAO = new PedidoDAO();
		produtoDAO = new ProdutoDAO();
		usuarioDAO = new UsuarioDAO();
		gson = new GsonBuilder().registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter()).create();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		String pathInfo = request.getPathInfo();

		try {
			if (pathInfo == null || pathInfo.equals("/")) {
				// Listar todos os pedidos ou filtrar por parâmetros
				handleListPedidos(request, response);
			} else {
				// Buscar pedido por ID
				String[] pathParts = pathInfo.split("/");
				if (pathParts.length == 2) {
					int id = Integer.parseInt(pathParts[1]);
					Pedido pedido = pedidoDAO.buscarPorId(id);

					if (pedido != null) {
						response.getWriter().write(gson.toJson(pedido));
					} else {
						response.setStatus(HttpServletResponse.SC_NOT_FOUND);
						response.getWriter().write("{\"erro\": \"Pedido não encontrado\"}");
					}
				}
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\": \"Erro interno do servidor\"}");
		}
	}

	private void handleListPedidos(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String compradorParam = request.getParameter("comprador");
		String vendedorParam = request.getParameter("vendedor");
		String produtoParam = request.getParameter("produto");
		String dataInicioParam = request.getParameter("dataInicio");
		String dataFimParam = request.getParameter("dataFim");

		List<Pedido> pedidos;

		if (compradorParam != null) {
			int idComprador = Integer.parseInt(compradorParam);
			pedidos = pedidoDAO.listarPorComprador(idComprador);
		} else if (vendedorParam != null) {
			int idVendedor = Integer.parseInt(vendedorParam);
			pedidos = pedidoDAO.listarPorVendedor(idVendedor);
		} else if (produtoParam != null) {
			int idProduto = Integer.parseInt(produtoParam);
			pedidos = pedidoDAO.listarPorProduto(idProduto);
		} else if (dataInicioParam != null && dataFimParam != null) {
			LocalDateTime dataInicio = LocalDateTime.parse(dataInicioParam);
			LocalDateTime dataFim = LocalDateTime.parse(dataFimParam);
			pedidos = pedidoDAO.listarPorPeriodo(dataInicio, dataFim);
		} else {
			pedidos = pedidoDAO.listarTodos();
		}

		response.getWriter().write(gson.toJson(pedidos));
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			StringBuilder sb = new StringBuilder();
			BufferedReader reader = request.getReader();
			String line;
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}

			PedidoRequest pedidoRequest = gson.fromJson(sb.toString(), PedidoRequest.class);

			// Validar dados
			if (pedidoRequest.idProduto <= 0 || pedidoRequest.idComprador <= 0) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\": \"IDs de produto e comprador são obrigatórios\"}");
				return;
			}

			// Verificar se produto e comprador existem
			Produto produto = produtoDAO.buscarPorId(pedidoRequest.idProduto);
			Usuario comprador = usuarioDAO.buscarPorId(pedidoRequest.idComprador);

			if (produto == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\": \"Produto não encontrado\"}");
				return;
			}

			if (comprador == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\": \"Comprador não encontrado\"}");
				return;
			}

			// Criar pedido
			Pedido pedido = new Pedido();
			pedido.setProduto(produto);
			pedido.setComprador(comprador);
			pedido.setDataPedido(pedidoRequest.dataPedido != null ? pedidoRequest.dataPedido : LocalDateTime.now());

			int novoId = pedidoDAO.inserir(pedido);

			if (novoId > 0) {
				pedido.setId(novoId);
				response.setStatus(HttpServletResponse.SC_CREATED);
				response.getWriter().write(gson.toJson(pedido));
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"erro\": \"Erro ao criar pedido\"}");
			}

		} catch (JsonSyntaxException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"JSON inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\": \"Erro interno do servidor\"}");
		}
	}

	@Override
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		String pathInfo = request.getPathInfo();

		if (pathInfo == null || pathInfo.equals("/")) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"ID do pedido é obrigatório na URL\"}");
			return;
		}

		try {
			String[] pathParts = pathInfo.split("/");
			if (pathParts.length != 2) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\": \"URL inválida\"}");
				return;
			}

			int id = Integer.parseInt(pathParts[1]);

			StringBuilder sb = new StringBuilder();
			BufferedReader reader = request.getReader();
			String line;
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}

			PedidoRequest pedidoRequest = gson.fromJson(sb.toString(), PedidoRequest.class);

			// Verificar se pedido existe
			Pedido pedidoExistente = pedidoDAO.buscarPorId(id);
			if (pedidoExistente == null) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"erro\": \"Pedido não encontrado\"}");
				return;
			}

			// Verificar se produto e comprador existem
			Produto produto = produtoDAO.buscarPorId(pedidoRequest.idProduto);
			Usuario comprador = usuarioDAO.buscarPorId(pedidoRequest.idComprador);

			if (produto == null || comprador == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\": \"Produto ou comprador não encontrado\"}");
				return;
			}

			// Atualizar pedido
			Pedido pedido = new Pedido();
			pedido.setId(id);
			pedido.setProduto(produto);
			pedido.setComprador(comprador);
			pedido.setDataPedido(
					pedidoRequest.dataPedido != null ? pedidoRequest.dataPedido : pedidoExistente.getDataPedido());

			boolean sucesso = pedidoDAO.atualizar(pedido);

			if (sucesso) {
				response.getWriter().write(gson.toJson(pedido));
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"erro\": \"Erro ao atualizar pedido\"}");
			}

		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"ID inválido\"}");
		} catch (JsonSyntaxException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"JSON inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\": \"Erro interno do servidor\"}");
		}
	}

	@Override
	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		String pathInfo = request.getPathInfo();

		if (pathInfo == null || pathInfo.equals("/")) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"ID do pedido é obrigatório na URL\"}");
			return;
		}

		try {
			String[] pathParts = pathInfo.split("/");
			if (pathParts.length == 2) {
				int id = Integer.parseInt(pathParts[1]);

				// Verificar se pedido existe
				Pedido pedido = pedidoDAO.buscarPorId(id);
				if (pedido == null) {
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					response.getWriter().write("{\"erro\": \"Pedido não encontrado\"}");
					return;
				}

				boolean sucesso = pedidoDAO.remover(id);

				if (sucesso) {
					response.getWriter().write("{\"mensagem\": \"Pedido removido com sucesso\"}");
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write("{\"erro\": \"Erro ao remover pedido\"}");
				}
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\": \"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\": \"Erro interno do servidor\"}");
		}
	}

	// Classe interna para request
	private static class PedidoRequest {
		int idProduto;
		int idComprador;
		LocalDateTime dataPedido;
	}

	// Adapter para LocalDateTime
	private static class LocalDateTimeAdapter
			implements com.google.gson.JsonSerializer<LocalDateTime>, com.google.gson.JsonDeserializer<LocalDateTime> {

		private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

		@Override
		public com.google.gson.JsonElement serialize(LocalDateTime localDateTime, java.lang.reflect.Type type,
				com.google.gson.JsonSerializationContext context) {
			return new com.google.gson.JsonPrimitive(localDateTime.format(formatter));
		}

		@Override
		public LocalDateTime deserialize(com.google.gson.JsonElement jsonElement, java.lang.reflect.Type type,
				com.google.gson.JsonDeserializationContext context) throws com.google.gson.JsonParseException {
			return LocalDateTime.parse(jsonElement.getAsString(), formatter);
		}
	}
}
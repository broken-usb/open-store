package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import modelo.dao.ProdutoDAO;
import modelo.dao.UsuarioDAO;
import modelo.entidade.Produto;
import modelo.entidade.Usuario;

@WebServlet("/produtos")
public class ProdutoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ProdutoDAO produtoDAO = new ProdutoDAO();
	private UsuarioDAO usuarioDAO = new UsuarioDAO();
	private Gson gson = new Gson();

	// GET - Listar produtos ou buscar por ID
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		String id = request.getParameter("id");
		String nome = request.getParameter("nome");
		String idUsuario = request.getParameter("idUsuario");
		String precoMin = request.getParameter("precoMin");
		String precoMax = request.getParameter("precoMax");

		try {
			if (id != null) {
				// Buscar por ID
				Produto produto = produtoDAO.buscarPorId(Integer.parseInt(id));
				if (produto != null) {
					response.getWriter().write(gson.toJson(produto));
				} else {
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					response.getWriter().write("{\"erro\":\"Produto não encontrado\"}");
				}
			} else if (nome != null) {
				// Buscar por nome
				List<Produto> produtos = produtoDAO.buscarPorNome(nome);
				response.getWriter().write(gson.toJson(produtos));
			} else if (idUsuario != null) {
				// Listar por usuário
				List<Produto> produtos = produtoDAO.listarPorUsuario(Integer.parseInt(idUsuario));
				response.getWriter().write(gson.toJson(produtos));
			} else if (precoMin != null && precoMax != null) {
				// Buscar por faixa de preço
				List<Produto> produtos = produtoDAO.buscarPorFaixaDePreco(Float.parseFloat(precoMin),
						Float.parseFloat(precoMax));
				response.getWriter().write(gson.toJson(produtos));
			} else {
				// Listar todos
				List<Produto> produtos = produtoDAO.listarTodos();
				response.getWriter().write(gson.toJson(produtos));
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\":\"Parâmetro inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro interno do servidor\"}");
		}
	}

	// POST - Criar produto
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			String json = lerCorpoRequisicao(request);
			JsonObject jsonObject = gson.fromJson(json, JsonObject.class);

			String nome = jsonObject.get("nome").getAsString();
			String descricao = jsonObject.get("descricao").getAsString();
			float preco = jsonObject.get("preco").getAsFloat();
			int idUsuario = jsonObject.get("idUsuario").getAsInt();

			Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
			if (usuario == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\":\"Usuário não encontrado\"}");
				return;
			}

			Produto produto = new Produto();
			produto.setNome(nome);
			produto.setDescricao(descricao);
			produto.setPreco(preco);
			produto.setUsuario(usuario);

			int id = produtoDAO.inserir(produto);
			if (id > 0) {
				produto.setId(id);
				response.setStatus(HttpServletResponse.SC_CREATED);
				response.getWriter().write(gson.toJson(produto));
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				response.getWriter().write("{\"erro\":\"Erro ao criar produto\"}");
			}
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\":\"Dados inválidos\"}");
		}
	}

	// PUT - Atualizar produto
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			String json = lerCorpoRequisicao(request);
			JsonObject jsonObject = gson.fromJson(json, JsonObject.class);

			int id = jsonObject.get("id").getAsInt();
			String nome = jsonObject.get("nome").getAsString();
			String descricao = jsonObject.get("descricao").getAsString();
			float preco = jsonObject.get("preco").getAsFloat();
			int idUsuario = jsonObject.get("idUsuario").getAsInt();

			Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
			if (usuario == null) {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().write("{\"erro\":\"Usuário não encontrado\"}");
				return;
			}

			Produto produto = new Produto();
			produto.setId(id);
			produto.setNome(nome);
			produto.setDescricao(descricao);
			produto.setPreco(preco);
			produto.setUsuario(usuario);

			boolean sucesso = produtoDAO.atualizar(produto);
			if (sucesso) {
				response.getWriter().write(gson.toJson(produto));
			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"erro\":\"Produto não encontrado ou erro ao atualizar\"}");
			}
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\":\"Dados inválidos\"}");
		}
	}

	// DELETE - Remover produto
	protected void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		String id = request.getParameter("id");

		if (id == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\":\"ID é obrigatório\"}");
			return;
		}

		try {
			boolean sucesso = produtoDAO.remover(Integer.parseInt(id));
			if (sucesso) {
				response.getWriter().write("{\"mensagem\":\"Produto removido com sucesso\"}");
			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				response.getWriter().write("{\"erro\":\"Produto não encontrado\"}");
			}
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"erro\":\"ID inválido\"}");
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"erro\":\"Erro interno do servidor\"}");
		}
	}

	private String lerCorpoRequisicao(HttpServletRequest request) throws IOException {
		StringBuilder sb = new StringBuilder();
		try (BufferedReader reader = request.getReader()) {
			String linha;
			while ((linha = reader.readLine()) != null) {
				sb.append(linha);
			}
		}
		return sb.toString();
	}
}
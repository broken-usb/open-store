package filtros;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = { "/produtos.jsp", "/pedidos.jsp", "/usuarios/*" })
public class AuthFilter implements Filter {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		// Verificar se existe sessão ativa
		HttpSession session = httpRequest.getSession(false);
		boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);

		if (!isLoggedIn) {
			// Redirecionar para login se não estiver logado
			httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
			return;
		}

		// Usuário logado, continuar com a requisição
		chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Inicialização do filtro se necessário
	}

	@Override
	public void destroy() {
		// Limpeza do filtro se necessário
	}
}
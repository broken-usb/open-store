package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;

import modelo.dao.UsuarioDAO;
import modelo.entidade.Usuario;

@WebServlet("/login")
@MultipartConfig
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;
    private Gson gson;

    public LoginServlet() {
        super();
        usuarioDAO = new UsuarioDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");

            if (email == null || senha == null || email.trim().isEmpty() || senha.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"erro\":\"Email e senha são obrigatórios\"}");
                return;
            }

            // Usar o método autenticar do DAO
            Usuario usuario = usuarioDAO.autenticar(email.trim(), senha);

            if (usuario != null) {
                // Criar sessão para o usuário
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario);
                
                response.setStatus(HttpServletResponse.SC_OK);
                // Não retornar a senha na resposta
                usuario.setSenha(null);
                out.print(gson.toJson(usuario));
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"erro\":\"Email ou senha incorretos\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"erro\":\"Erro interno do servidor\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Logout
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"mensagem\":\"Logout realizado com sucesso\"}");
    }
}
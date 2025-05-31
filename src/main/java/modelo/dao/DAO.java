package modelo.dao;

import java.util.List;

public interface DAO<T> {

	public int inserir(T entidade);

	public boolean atualizar(T entidade);

	public boolean remover(int id);

	public T buscarPorId(int id);

	public List<T> listarTodos();
}
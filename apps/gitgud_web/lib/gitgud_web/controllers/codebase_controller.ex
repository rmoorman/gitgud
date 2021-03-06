defmodule GitGud.Web.CodebaseController do
  @moduledoc """
  Module responsible for CRUD actions on `GitGud.Repo`.
  """

  use GitGud.Web, :controller

  alias GitGud.Repo
  alias GitGud.RepoQuery
  alias GitGud.GitCommit
  alias GitGud.GitTree
  alias GitGud.GitTreeEntry

  plug :put_layout, :repo

  action_fallback GitGud.Web.FallbackController

  @doc """
  Renders a repository codebase overview.
  """
  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, %{"user_name" => user_name, "repo_name" => repo_name} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      if Repo.empty?(repo),
        do: render(conn, "initialize.html", repo: repo),
      else: with {:ok, head} <- Repo.git_head(repo),
                 {:ok, tree} <- Repo.git_tree(head), do:
              render(conn, "show.html", repo: repo, revision: head, tree: tree, tree_path: [], stats: stats(head))
    end || {:error, :not_found}
  end

  @doc """
  Renders all branches of a repository.
  """
  @spec branches(Plug.Conn.t, map) :: Plug.Conn.t
  def branches(conn, %{"user_name" => user_name, "repo_name" => repo_name} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, head} <- Repo.git_head(repo),
           {:ok, branches} <- Repo.git_branches(repo), do:
        render(conn, "branch_list.html", repo: repo, head: head, branches: branches)
    end || {:error, :not_found}
  end

  @doc """
  Renders all tags of a repository.
  """
  @spec tags(Plug.Conn.t, map) :: Plug.Conn.t
  def tags(conn, %{"user_name" => user_name, "repo_name" => repo_name} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, tags} <- Repo.git_tags(repo), do:
        render(conn, "tag_list.html", repo: repo, tags: tags)
    end || {:error, :not_found}
  end

  @doc """
  Renders a single commit.
  """
  @spec commit(Plug.Conn.t, map) :: Plug.Conn.t
  def commit(conn, %{"user_name" => user_name, "repo_name" => repo_name, "oid" => oid} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, commit} <- Repo.git_object(repo, oid),
           {:ok, new_tree} <- Repo.git_tree(commit),
           {:ok, parent} <- GitCommit.first_parent(commit),
           {:ok, old_tree} <- Repo.git_tree(parent),
           {:ok, diff} <- Repo.git_diff(old_tree, new_tree), do:
        render(conn, "commit.html", repo: repo, commit: commit, diff: diff)
    end || {:error, :not_found}
  end

  @doc """
  Renders all commits for a specific revision.
  """
  @spec history(Plug.Conn.t, map) :: Plug.Conn.t
  def history(conn, %{"user_name" => user_name, "repo_name" => repo_name, "revision" => revision, "path" => []} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, object, reference} <- Repo.git_revision(repo, revision),
           {:ok, history} <- Repo.git_history(object), do:
        render(conn, "commit_list.html", repo: repo, revision: reference || object, commits: history, tree_path: [])
    end || {:error, :not_found}
  end

  def history(conn, %{"user_name" => user_name, "repo_name" => repo_name, "revision" => revision, "path" => tree_path} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, object, reference} <- Repo.git_revision(repo, revision),
           {:ok, history} <- Repo.git_history(object, pathspec: Path.join(tree_path)), do:
        render(conn, "commit_list.html", repo: repo, revision: reference || object, commits: history, tree_path: tree_path)
    end || {:error, :not_found}
  end

  def history(conn, %{"user_name" => user_name, "repo_name" => repo_name} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, reference} <- Repo.git_head(repo),
           {:ok, history} <- Repo.git_history(reference), do:
        render(conn, "commit_list.html", repo: repo, revision: reference, commits: history)
    end || {:error, :not_found}
  end

  @doc """
  Renders a tree for a specific revision and path.
  """
  @spec tree(Plug.Conn.t, map) :: Plug.Conn.t
  def tree(conn, %{"user_name" => user_name, "repo_name" => repo_name, "revision" => revision, "path" => []} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, object, reference} <- Repo.git_revision(repo, revision),
           {:ok, tree} <- Repo.git_tree(object), do:
        render(conn, "show.html", repo: repo, revision: reference || object, tree: tree, tree_path: [], stats: stats(reference || object))
    end || {:error, :not_found}
  end

  def tree(conn, %{"user_name" => user_name, "repo_name" => repo_name, "revision" => revision, "path" => tree_path} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, object, reference} <- Repo.git_revision(repo, revision),
           {:ok, tree} <- Repo.git_tree(object),
           {:ok, tree_entry} <- GitTree.by_path(tree, Path.join(tree_path)),
           {:ok, tree} <- GitTreeEntry.target(tree_entry), do:
        render(conn, "tree.html", repo: repo, revision: reference || object, tree: tree, tree_path: tree_path)
    end || {:error, :not_found}
  end

  @doc """
  Renders a blob for a specific revision and path.
  """
  @spec blob(Plug.Conn.t, map) :: Plug.Conn.t
  def blob(conn, %{"user_name" => user_name, "repo_name" => repo_name, "revision" => revision, "path" => blob_path} = _params) do
    if repo = RepoQuery.user_repo(user_name, repo_name, viewer: current_user(conn)) do
      repo = Repo.open(repo)
      with {:ok, object, reference} <- Repo.git_revision(repo, revision),
           {:ok, tree} <- Repo.git_tree(object),
           {:ok, tree_entry} <- GitTree.by_path(tree, Path.join(blob_path)),
           {:ok, blob} <- GitTreeEntry.target(tree_entry), do:
        render(conn, "blob.html", repo: repo, revision: reference || object, blob: blob, tree_path: blob_path)
    end || {:error, :not_found}
  end

  #
  # Helpers
  #

  defp stats(%{repo: repo} = revision) do
    with {:ok, history} <- Repo.git_history(revision),
         {:ok, branches} <- Repo.git_branches(repo),
         {:ok, tags} <- Repo.git_tags(repo) do
      %{commits: Enum.count(history.enum), branches: Enum.count(branches.enum), tags: Enum.count(tags.enum)}
    else
      {:error, _reason} ->
        %{commits: 0, branches: 0, tags: 0}
    end
  end
end

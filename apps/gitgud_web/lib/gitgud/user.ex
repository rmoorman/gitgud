import Phoenix.HTML, only: [raw: 1]

import GitGud.Web.Gravatar, only: [gravatar: 1]

defimpl Phoenix.Param, for: GitGud.User do
  def to_param(user), do: user.login
end

defimpl Phoenix.HTML.Safe, for: GitGud.User do
  def to_iodata(user) do
    Phoenix.HTML.Safe.to_iodata([gravatar(user), raw(user.login)])
  end
end

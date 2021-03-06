defmodule GitGud.Umbrella.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [apps_path: "apps",
     version: @version,
     name: "Git Gud",
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     docs: docs()]
  end

  #
  # Helpers
  #

  defp deps do
    [{:distillery, "~> 2.0"},
     {:ex_doc, "~> 0.19", only: :dev, runtime: false}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/db/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  defp docs do
    [
#     main: "GitGud",
      source_ref: "v#{@version}",
      canonical: "https://git.limo",
      source_url: "https://github.com/almightycouch/gitgud",
      extras: [
        "guides/Getting Started.md",
      ],
      groups_for_modules: [
        "Database": [
          GitGud.DB,
          GitGud.DBQueryable
        ],
        "Authorization": [
          GitGud.Authorization,
          GitGud.AuthorizationPolicies
        ],
        "Schemas": [
          GitGud.Auth,
          GitGud.Auth.Provider,
          GitGud.Email,
          GitGud.Maintainer,
          GitGud.Repo,
          GitGud.RepoQuery,
          GitGud.SSHKey,
          GitGud.User,
          GitGud.UserQuery
        ],
        "Deployment": [
          GitGud.ReleaseTasks
        ],
        "Git helper structs": [
          GitGud.GitBlob,
          GitGud.GitCommit,
          GitGud.GitDiff,
          GitGud.GitReference,
          GitGud.GitTag,
          GitGud.GitTree,
          GitGud.GitTreeEntry,
        ],
        "Git Transfer Protocols": [
          GitGud.SSHServer,
          GitGud.SmartHTTPBackend
        ],
        "OAuth2.0": [
          GitGud.OAuth2.GitHub
        ],
        "GraphQL": [
          GitGud.GraphQL.Resolvers,
          GitGud.GraphQL.Schema,
          GitGud.GraphQL.Types
        ],
        "Email Delivery": [
          GitGud.Mailer
        ],
        "Web": [
          GitGud.Web,
          GitGud.Web.AuthenticationPlug,
          GitGud.Web.CodebaseController,
          GitGud.Web.DateTimeFormatter,
          GitGud.Web.EmailController,
          GitGud.Web.Endpoint,
          GitGud.Web.ErrorHelpers,
          GitGud.Web.ErrorView,
          GitGud.Web.FallbackController,
          GitGud.Web.Gettext,
          GitGud.Web.Gravatar,
          GitGud.Web.LandingPageController,
          GitGud.Web.MaintainerController,
          GitGud.Web.NavigationHelpers,
          GitGud.Web.OAuth2Controller,
          GitGud.Web.PaginationHelpers,
          GitGud.Web.ReactComponents,
          GitGud.Web.RepoController,
          GitGud.Web.Router.Helpers,
          GitGud.Web.SSHKeyController,
          GitGud.Web.SessionController,
          GitGud.Web.UserController,
          GitGud.Web.UserSocket
        ],
        "Git low-level APIs": [
          GitRekt.Git,
          GitRekt.Packfile,
          GitRekt.WireProtocol,
          GitRekt.WireProtocol.ReceivePack,
          GitRekt.WireProtocol.UploadPack
        ],
      ]
    ]
  end
end

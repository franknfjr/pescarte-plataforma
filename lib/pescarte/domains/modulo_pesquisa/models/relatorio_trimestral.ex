defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @type t :: %RelatorioTrimestral{
          id: integer,
          titulo: binary,
          resumo: binary,
          introducao: binary,
          embasamento_teorico: binary,
          resultados_preliminares: binary,
          atividades_academicas: binary,
          atividades_nao_academicas: binary,
          referencias: binary,
          status: atom,
          link: binary,
          ano: integer,
          mes: integer,
          pesquisador: Pesquisador.t(),
          id_publico: binary
        }

  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(ano mes pesquisador_id)a

  @optional_fields ~w(
    titulo
    resumo
    introducao
    embasamento_teorico
    resultados_preliminares
    atividades_academicas
    atividades_nao_academicas
    referencias
    status
    link
  )a

  schema "relatorio_trimestral_pesquisa" do
    field :ano, :integer
    field :mes, :integer
    field :link, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true
    field :status, Ecto.Enum, values: @status, default: :pendente

    field :titulo, :string
    field :resumo, :string
    field :introducao, :string
    field :embasamento_teorico, :string
    field :resultados_preliminares, :string
    field :atividades_academicas, :string
    field :atividades_nao_academicas, :string
    field :referencias, :string

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end

  @spec changeset(RelatorioTrimestral.t(), map) :: changeset
  def changeset(%RelatorioTrimestral{} = relatorio_trimestral, attrs) do
    relatorio_trimestral
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_id)
  end
end
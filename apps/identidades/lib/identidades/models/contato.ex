defmodule Identidades.Models.Contato do
  use Database, :model

  alias Identidades.Models.Endereco

  @type t :: %Contato{
          email_principal: binary,
          celular_principal: binary,
          emails_adicionais: list(binary),
          celulares_adicionais: list(binary),
          endereco: Endereco.t(),
          id_publico: binary
        }

  @optional_fields ~w(emails_adicionais celulares_adicionais endereco_cep)a
  @required_fields ~w(email_principal celular_principal)a

  @primary_key {:email_principal, :string, autogenerate: false}
  schema "contato" do
    field :celular_principal, :string
    field :emails_adicionais, {:array, :string}
    field :celulares_adicionais, {:array, :string}
    field :id_publico, Database.Types.PublicId, autogenerate: true

    belongs_to :endereco, Endereco,
      foreign_key: :endereco_cep,
      references: :cep,
      type: :string

    timestamps()
  end

  @spec changeset(Contato.t(), map) :: changeset
  def changeset(%Contato{} = contato, attrs) do
    contato
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required([:email_principal, :celular_principal])
    |> unsafe_validate_unique(:email_principal, Database.LeituraRepo)
    |> unique_constraint(:email_principal)
    |> validate_change(:emails_adicionais, &validate_duplicates/2)
    |> validate_change(:celulares_adicionais, &validate_duplicates/2)
  end

  defp validate_duplicates(field, values) do
    duplicates = values -- Enum.uniq(values)

    if Enum.empty?(duplicates) do
      []
    else
      error = Enum.join(duplicates, ",")
      [{field, "valores duplicados: #{error}"}]
    end
  end
end

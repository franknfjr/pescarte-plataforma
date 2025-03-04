defmodule Pescarte.ModuloPesquisa.Models.LinhaPesquisaTest do
  use Database.DataCase, async: true

  import ModuloPesquisa.Factory

  alias ModuloPesquisa.Models.LinhaPesquisa

  @moduletag :unit

  test "changeset válido com campos obrigatórios" do
    nucleo_pesquisa = insert(:nucleo_pesquisa)

    attrs = %{
      nucleo_pesquisa_letra: nucleo_pesquisa.letra,
      desc_curta: "Desc Curta",
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(%LinhaPesquisa{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nucleo_pesquisa_letra) == nucleo_pesquisa.letra
    assert get_change(changeset, :desc_curta) == "Desc Curta"
    assert get_change(changeset, :numero) == 123
  end

  test "changeset válido com campo adicional" do
    nucleo_pesquisa = insert(:nucleo_pesquisa)
    responsavel_lp = insert(:pesquisador)

    attrs = %{
      nucleo_pesquisa_letra: nucleo_pesquisa.letra,
      desc_curta: "Desc Curta",
      numero: 123,
      desc: "Desc",
      responsavel_lp_id: responsavel_lp.id_publico
    }

    changeset = LinhaPesquisa.changeset(%LinhaPesquisa{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nucleo_pesquisa_letra) == nucleo_pesquisa.letra
    assert get_change(changeset, :desc_curta) == "Desc Curta"
    assert get_change(changeset, :numero) == 123
    assert get_change(changeset, :desc) == "Desc"
    assert get_change(changeset, :responsavel_lp_id) == responsavel_lp.id_publico
  end

  test "changeset inválido sem campo obrigatório" do
    attrs = %{
      desc_curta: "Desc Curta",
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(%LinhaPesquisa{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :nucleo_pesquisa_letra)
  end

  test "changeset inválido com desc_curta longa demais" do
    attrs = %{
      nucleo_pesquisa_letra: insert(:nucleo_pesquisa).letra,
      desc_curta: String.duplicate("a", 91),
      numero: 123
    }

    changeset = LinhaPesquisa.changeset(%LinhaPesquisa{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc_curta)
  end

  test "changeset inválido com desc longa demais" do
    attrs = %{
      nucleo_pesquisa_letra: insert(:nucleo_pesquisa).letra,
      desc_curta: "Desc Curta",
      numero: 123,
      desc: String.duplicate("a", 281)
    }

    changeset = LinhaPesquisa.changeset(%LinhaPesquisa{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :desc)
  end
end

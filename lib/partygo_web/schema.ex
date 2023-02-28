defmodule PartygoWeb.Schema do
  use Absinthe.Schema
  alias PartygoWeb.UserResolver
  alias PartygoWeb.PartyResolver

  import_types PartygoWeb.Schema.Party
  import_types PartygoWeb.Schema.User

  def context(ctx) do
    loader = Dataloader.new
             |> Dataloader.add_source(User, Partygo.Dataloader.data())
             |> Dataloader.add_source(Party, Partygo.Dataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  query do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:user))) do
      (&UserResolver.all_users/3) |> handle_errors |> resolve
    end

    @desc "Get all parties"
    field :all_parties, non_null(list_of(non_null(:party))) do
      (&PartyResolver.all_parties/3) |> handle_errors |> resolve
    end
  end

  mutation do
    @desc "Create a new party"
    field :create_party, :party do
      # TODO: esto probablemente tenga que venir en el JWT
      arg :owner_id, non_null(:id)

      arg :title, non_null(:string)
      arg :description, non_null(:string)
      arg :date, non_null(:datetime)
      arg :latitude, non_null(:decimal)
      arg :longitude, non_null(:decimal)
      arg :age_from, :integer
      arg :age_to, :integer

      (&PartyResolver.create_party/3) |> handle_errors |> resolve
    end

    @desc "Delete a party"
    field :delete_party, :boolean do
      # TODO: pasar por JWT
      arg :owner_id, non_null(:id)
      arg :party_id, non_null(:id)

      (&PartyResolver.delete_party/3) |> handle_errors |> resolve
    end

    @desc "Update a party"
    field :update_party, :party do
      # TODO: pasar por JWT
      arg :owner_id, non_null(:id)
      arg :party_id, non_null(:id)
      arg :edit, non_null(:party_edit)

      (&PartyResolver.update_party/3) |> handle_errors |> resolve
    end
  end

  def handle_errors(f) do
    fn source, args, info -> 
      case Absinthe.Resolution.call(f, source, args, info) do
        {:error, %Ecto.Changeset{} = changeset} -> format_changeset(changeset)
        val -> val
      end
    end
  end

  def format_changeset(%Ecto.Changeset{} = changeset) do
    errors = changeset.errors |> Enum.map(fn ({key, {value, context}}) -> [message: "#{key}: #{value}", details: context] end)
    {:error, errors}
  end
end

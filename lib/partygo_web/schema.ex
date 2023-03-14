defmodule PartygoWeb.Schema do
  use Absinthe.Schema
  alias PartygoWeb.UserResolver
  alias PartygoWeb.PartyResolver

  import_types PartygoWeb.Schema.Party
  import_types PartygoWeb.Schema.User

  scalar :db_id do
    parse fn input -> 
      if is_integer(input.value) do
        {:ok, input.value}
      else 
        case Integer.parse(input.value) do
          {n, _} -> {:ok, n}
          :error -> :error
        end
      end
    end
  end

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

    @desc "Get all parties near a certain point"
    field :all_parties_near, non_null(list_of(non_null(:party))) do
      arg :latitude, non_null(:float)
      arg :longitude, non_null(:float)

      (&PartyResolver.parties_near/3) |> handle_errors |> resolve
    end

    @desc "Get the user's ticket for a certain party"
    field :ticket_for_party, :string do
      arg :party_id, non_null(:db_id)

      (&PartyResolver.generate_jwt_ticket/2) |> handle_errors |> resolve
    end
  end

  mutation do
    @desc "Create a new party"
    field :create_party, :party do
      arg :title, non_null(:string)
      arg :description, non_null(:string)
      arg :date, non_null(:datetime)
      arg :latitude, non_null(:float)
      arg :longitude, non_null(:float)
      arg :age_from, :integer
      arg :age_to, :integer

      (&PartyResolver.create_party/3) |> handle_errors |> resolve
    end

    @desc "Delete a party"
    field :delete_party, :boolean do
      arg :party_id, non_null(:db_id)

      (&PartyResolver.delete_party/3) |> handle_errors |> resolve
    end

    @desc "Edit a party"
    field :edit_party, :party do
      arg :party_id, non_null(:db_id)
      arg :edit, non_null(:party_edit)

      (&PartyResolver.update_party/3) |> handle_errors |> resolve
    end

    @desc "Assist the user to a party"
    field :assist_to_party, :boolean do
      arg :party_id, non_null(:db_id)

      (&UserResolver.assist_to_party/3) |> handle_errors |> resolve
    end

    @desc "Validate a JWT ticket and assign the user as inside the party" 
    field :validate_ticket, :boolean do
      arg :ticket, non_null(:string)
      arg :party_id, non_null(:db_id)

      (&PartyResolver.validate_jwt_ticket/2) |> handle_errors |> resolve
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
    errors = changeset.errors |> Enum.map(fn ({key, {value, context}}) -> [message: "#{key}: #{value}", details: context |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)] end)
    {:error, errors}
  end
end

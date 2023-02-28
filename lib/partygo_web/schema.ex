defmodule PartygoWeb.Schema do
  use Absinthe.Schema
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types Absinthe.Type.Custom
  alias PartygoWeb.UserResolver
  alias PartygoWeb.PartyResolver

  def context(ctx) do
    loader = Dataloader.new
             |> Dataloader.add_source(User, Partygo.Dataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  enum :sex do
    value :male
    value :female
  end

  object :user do
    field :id, non_null(:id)
    field :uid, non_null(:string)
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :dob, non_null(:date)
    field :tag, non_null(:string)
    field :sex, :sex
  end

  object :party do
    field :id, non_null(:id)
    field :owner, non_null(:user), resolve: dataloader(User)
    field :title, non_null(:string)
    field :description, non_null(:string)
    field :date, non_null(:datetime)
    field :latitude, non_null(:decimal)
    field :longitude, non_null(:decimal)
    field :age_from, :integer
    field :age_to, :integer
    field :assisting, non_null(list_of(non_null(:user))), resolve: dataloader(User)
  end

  query do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:user))) do
      resolve(&UserResolver.all_users/3)
    end

    @desc "Get all parties"
    field :all_parties, non_null(list_of(non_null(:party))) do
      resolve(&PartyResolver.all_parties/3)
    end
  end

  mutation do
    @desc "Create a new party"
    field :create_party, :party do
      # esto probablemente tenga que venir en el JWT
      arg :owner_id, non_null(:id)

      arg :title, non_null(:string)
      arg :description, non_null(:string)
      arg :date, non_null(:datetime)
      arg :latitude, non_null(:decimal)
      arg :longitude, non_null(:decimal)
      arg :age_from, :integer
      arg :age_to, :integer

      resolve(&PartyResolver.create_party/3)
    end
  end
end

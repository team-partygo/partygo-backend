defmodule PartygoWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  alias PartygoWeb.UserResolver
  alias PartygoWeb.PartyResolver

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
    field :owner, non_null(:user)
    field :title, :string
    field :description, non_null(:string)
    field :date, non_null(:datetime)
    field :latitude, non_null(:decimal)
    field :longitude, non_null(:decimal)
    field :age_from, :integer
    field :age_to, :integer
    field :assisting, list_of(:user)
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
end

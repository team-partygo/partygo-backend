defmodule PartygoWeb.Schema do
  use Absinthe.Schema
  import_types Absinthe.Type.Custom
  alias PartygoWeb.UserResolver

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

  query do
    @desc "Get all users"
    field :all_users, non_null(list_of(non_null(:user))) do
      resolve(&UserResolver.all_users/3)
    end
  end
end

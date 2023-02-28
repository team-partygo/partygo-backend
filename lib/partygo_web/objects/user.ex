defmodule PartygoWeb.Schema.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types Absinthe.Type.Custom
  
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
    field :parties, non_null(list_of(:party)), resolve: dataloader(Party)
    field :assisting_to, non_null(list_of(:party)), resolve: dataloader(Party)
  end
end

defmodule PartygoWeb.Schema.Party do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

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

  input_object :party_edit do
    field :description, :string
    field :date, :datetime
    # TODO: decidir si se puede cambiar el lugar de la fiesta
  end
end

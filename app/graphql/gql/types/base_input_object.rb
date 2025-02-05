# Copyright (C) 2012-2022 Zammad Foundation, https://zammad-foundation.org/

module Gql::Types
  class BaseInputObject < GraphQL::Schema::InputObject
    include Gql::Concerns::HandlesServices

    argument_class Gql::Types::BaseArgument
  end
end

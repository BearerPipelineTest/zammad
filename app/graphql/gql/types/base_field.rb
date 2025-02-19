# Copyright (C) 2012-2022 Zammad Foundation, https://zammad-foundation.org/

module Gql::Types
  class BaseField < GraphQL::Schema::Field
    include Gql::Concerns::HandlesAuthorization
    include Gql::Concerns::SkipsUnauthorizedFields

    argument_class Gql::Types::BaseArgument
  end
end

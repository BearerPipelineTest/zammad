# Copyright (C) 2012-2022 Zammad Foundation, https://zammad-foundation.org/

module Gql::Mutations
  class User::Update < BaseMutation
    description 'Update an existing user.'

    argument :id, GraphQL::Types::ID, description: 'The user ID', as: :current_user, loads: Gql::Types::UserType
    argument :input, Gql::Types::Input::UserInputType, description: 'The user data'

    field :user, Gql::Types::UserType, null: false, description: 'The created user.'

    def load_id(id:)
      Gql::ZammadSchema.verified_object_from_id(id, type: ::User, user: context.current_user)
    end

    def authorized?(current_user:, input:)
      Pundit.authorize(context.current_user, current_user, :update?)
    end

    def resolve(current_user:, input:)
      { user: update(current_user, input) }
    end

    private

    def update(current_user, input)
      user_data = input.to_h

      convert_object_attribute_values(user_data)
      set_core_workflow_information(user_data, ::User, 'update')
      execute_service(::User::CheckAttributesService, user_data: user_data)

      current_user.with_lock do
        current_user.update!(user_data)
      end

      current_user
    end
  end
end

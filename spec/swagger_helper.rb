require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      definitions: {
        player_basic: {
          type: :object,
          properties: {
            id: { type: :integer, readOnly: true },
            firstname: { type: :string },
            lastname: { type: :string }
          }
        },
        player: {
          allOf: [
            { "$ref" => "#/definitions/player_basic" },
            {
              type: :object,
              properties: {
                email: { type: :string },
                position: { type: :string, "x-nullable": true },
                club: { type: :string, "x-nullable": true },
                date_of_birth: { type: :string, "x-nullable": true, description: "ISO-8601 timestamp"  }
              }
            }
          ]
        },
        player_edit: {
          allOf: [
            { "$ref" => "#/definitions/player" },
            {
              type: :object,
              properties: {
                password: { type: :string },
                password_confirmation: { type: :string }
              }
            }
          ]
        }
      },
      securityDefinitions: {
        Bearer: {
          description: "API token. Value should be informat: 'Bearer [token]'",
          type: :apiKey,
          name: 'Authorization',
          in: :header
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end

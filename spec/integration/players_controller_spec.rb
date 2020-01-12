require "rails_helper"
require "swagger_helper"

RSpec.describe "Player API", swagger_doc: 'v1/swagger.yaml' do

  path "/players" do
    parameter name: 'Accept-Language', in: :header, type: :string, required: false

    post "Creates a new Player" do
      tags "Player"
      produces "application/json"
      consumes "application/json"

      parameter name: :params, in: :body, schema: {'$ref' => '#/definitions/player_edit' }

      response "200", "A new player is created" do
        schema type: :object, properties: {
          data: { '$ref' => '#/definitions/player' },
          status: { type: :string, 'x-nullable': true }
        }

        let!(:params) {
          {
            firstname: 'Jordan',
            lastname: 'Junior',
            email: 'jj@example.com',
            club: 'Strikes FC',
            position: 'Attacking Midfielder Left/Right',
            date_of_birth: "2005-12-25",
            password: '12345678',
            password_confirmation: '12345678'
          }
        }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["data"]["firstname"]).to eq params[:firstname]
          expect(body["data"]["lastname"]).to eq params[:lastname]
          expect(body["data"]["email"]).to eq params[:email]
          expect(body["data"]["position"]).to eq params[:position]
          expect(body["data"]["club"]).to eq params[:club]
          expect(body["data"]["date_of_birth"]).to eq params[:date_of_birth]
        end
      end

      response "400", "Bad request" do
        schema type: :object, properties: {
          data: { type: :object, 'x-nullable': true },
          status: { type: :string }
        }

        let!(:params) {
          {
            firstname: 'Jordan',
            lastname: 'Junior',
            email: 'jj@example.com',
            club: 'Strikes FC',
            position: 'Attacking Midfielder Left/Right',
            date_of_birth: "2005-12-25",
            password: '1234567',
            password_confirmation: '1234567'
          }
        }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["data"]).to be_nil
          expect(body["status"]).to eq "Password is too short (minimum is 8 characters)"
        end
      end

    end
  end

  path "/players/{id}" do
    parameter name: 'Accept-Language', in: :header, type: :string, required: false
    parameter name: :id, in: :path, type: :integer, required: true, description: "ID of the player"

    let!(:user) { create(:player, club: 'Fancy FC', position: 'Striker') }
    let!(:Authorization) { get_authorization_header(user) }

    get "Shows details for a player" do
      tags "Player"
      produces "application/json"
      security [Bearer: []]

      let!(:other_player) { create(:player, firstname: 'John', lastname: 'Smith', club: 'Santos', position: 'Striker') }
      let!(:id) { other_player.id }

      response "200", "Returns details for player" do
        schema type: :object, properties: {
          data: { '$ref' => '#/definitions/player' },
          status: { type: :string, 'x-nullable': true }
        }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["status"]).to be_nil
          expect(body["data"]).to_not be_nil
          expect(body["data"]["id"]).to eq other_player.id
          expect(body["data"]["firstname"]).to eq other_player.firstname
          expect(body["data"]["lastname"]).to eq other_player.lastname
          expect(body["data"]["email"]).to eq other_player.email
        end
      end

      response "404", "Not Found" do
        schema type: :object, properties: {
          data: { type: :object, "x-nullable": true },
          status: { type: :string,  }
        }
        let!(:id) { -1 }

        run_test!
      end
    end

    put "Updates details for a player" do
      tags "Player"
      consumes "application/json"
      produces "application/json"
      security [Bearer: []]

      parameter name: :params, in: :body, schema: { "$ref" => "#/definitions/player_edit" }

      let!(:other_player) { create(:player, firstname: 'John', lastname: 'Smith', club: 'Santos', position: 'Striker') }
      let!(:id) { other_player.id }

      let!(:params) {
        {
          date_of_birth: "2004-12-13"
        }
      }

      response "200", "Returns details for player" do
        schema type: :object, properties: {
          data: { '$ref' => '#/definitions/player' },
          status: { type: :string, 'x-nullable': true }
        }

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body["data"]["date_of_birth"]).to eq params[:date_of_birth]
        end
      end
    end
  end

  path "/players/follow" do
    post "Follow player identified by the id" do
      tags "Player"
      produces "application/json"
      consumes "application/json"
      security [Bearer: []]

      parameter name: 'Accept-Language', in: :header, type: :string, required: false
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          player_to_follow_id: { type: :integer, description: "ID of the player to follow" }
        }, required: ["player_to_follow_id"]
      }

      let!(:player) { create(:player, firstname: 'John', lastname: 'Smith', club: 'FCK', position: 'Goalkeeper') }
      let!(:player_to_follow) { create(:player, firstname: 'Mo', lastname: 'Salah', club: 'HIK', position: 'Striker') }

      let!(:Authorization) { get_authorization_header(player) }
      let!(:params) {
        {
          player_to_follow_id: player_to_follow.id
        }
      }

      response "200", "Adds current user to the player identified by ID's followers" do
        schema type: :object, properties: {
          data: { type: :object, 'x-nullable': true },
          status: { type: :string, 'x-nullable': true }
        }

        run_test! do
          expect(player_to_follow.followers.count).to eq 1
          expect(player_to_follow.followers.first.id).to eq player.id
        end
      end
    end
  end

  path "/players/{id}/followers" do
    parameter name: 'Accept-Language', in: :header, type: :string, required: false

    get "Returns a list of followers for the player identified by id" do
      tags "Player"
      produces "application/json"
      security [Bearer: []]

      parameter name: :id, in: :path, type: :integer, required: true, description: "ID of the player"
      parameter name: :offset, in: :query, type: :integer, required: false,
        description: "Optional offset for paging. Defaults to 0"
      parameter name: :limit, in: :query, type: :integer, required: false,
        description: "Optional page size. Defaults to 20"

      let!(:follower_1) { create(:player, firstname: 'John', lastname: 'Smith', club: 'Santos') }
      let!(:follower_2) { create(:player, firstname: 'Jane', lastname: 'Doe', position: 'Left Back') }
      let!(:follower_3) { create(:player, firstname: 'Fernando') }
      let!(:follower_4) { create(:player, firstname: 'Virgil', club: 'Brøndby', position: 'Central Defender') }
      let!(:follower_5) { create(:player, firstname: 'Steven', club: 'Vejle', position: 'Central Defender') }

      let!(:player) {
        create(:player, firstname: 'John', lastname: 'Smith', club: 'FCK', position: 'Goalkeeper',
          followers: [follower_1, follower_2, follower_3, follower_4, follower_5])
      }
      let!(:id) { player.id }

      response "200", "Returns a list of people following this Player" do
        schema type: :object, properties: {
          data: {
            type: :array,
            items: { '$ref' => '#/definitions/player_basic' }
          },
          status: { type: :string, 'x-nullable': true }
        }
        let!(:user) { create(:player, club: 'Fancy FC', position: 'Striker') }
        let!(:Authorization) { get_authorization_header(user) }

        context "Player has followers" do
          after do |example|
            example.metadata[:response][:examples] = {
              "Returns a list of followers" => JSON.parse(response.body, symbolize_names: true)
            }
          end

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body["status"]).to be_nil
            expect(body["data"].count).to eq 5

            # check ordering by firstname
            expect(body["data"][0]["id"]).to eq follower_3.id
            expect(body["data"][1]["id"]).to eq follower_2.id
            expect(body["data"][2]["id"]).to eq follower_1.id
            expect(body["data"][3]["id"]).to eq follower_5.id
            expect(body["data"][4]["id"]).to eq follower_4.id
          end
        end

        context "with limit" do
          let!(:limit) { 2 }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body["data"].count).to eq 2
          end
        end

        context "with offset" do
          let!(:limit) { 1 }
          let!(:offset) { 2 }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body["data"].count).to eq 1
            expect(body["data"][0]["id"]).to eq follower_1.id
          end
        end
      end

      response "401", "Not Authorized" do
        schema type: :object, properties: {
          data: { type: :object, "x-nullable": true },
          status: { type: :string,  }
        }

        let!(:Authorization) { {} }

        run_test!
      end

      response "404", "Not Found" do
        schema type: :object, properties: {
          data: { type: :object, "x-nullable": true },
          status: { type: :string,  }
        }

        let!(:user) { create(:player, club: 'Fancy FC', position: 'Striker') }
        let!(:Authorization) { get_authorization_header(user) }
        let!(:id) { -1 }

        run_test!
      end
    end
  end

  path "/players/logout" do
    parameter name: 'Accept-Language', in: :header, type: :string, required: false

    delete "Logs out the current user. The access token is invalidated." do
      tags "Login"
      security [Bearer: []]
      let!(:player) {
        Player.create(
          firstname: "Mo",
          lastname: "Salah",
          email: "ms@example.com",
          password: "testtest",
          password_confirmation: "testtest")
      }

      response "200", "User is now logged out (JWT is revoked)" do
        let!(:Authorization) { get_authorization_header(player) }

        run_test!
      end
    end
  end

  path "/players/login" do
    parameter name: "Accept-Language", in: :header, type: :string, required: false

    post "Verifies credentials and returns access token" do
      tags "Login"
      consumes "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
        }, required: %w(email password)
      }

      response "200", "Login successful" do
        schema type: :object, properties: {
          status: { type: :string, "x-nullable": true },
          data: {
            type: :object,
            properties: {
              token: { type: :string }
            }
          }
        }

        let(:params) {
          {
            email: "ms@example.com",
            password: "testtest"
          }
        }

        before do
          Player.create(
            firstname: "Mo",
            lastname: "Salah",
            email: "ms@example.com",
            password: "testtest",
            password_confirmation: "testtest"
          )
        end

        run_test!
      end

    end
  end
end


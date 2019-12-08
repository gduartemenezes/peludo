# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  before do
    user.confirm
    sign_in(user)
  end

  describe 'DELETE #destroy' do
    subject(:deactivate_user) do
      delete user_registration_path, params: { id: user.id }
    end

    let!(:user) { create(:user) }
    let!(:lost_pet) { create(:pet, user: user, situation: :lost, deactivated_at: nil) }
    let!(:found_pet) { create(:pet, user: user, situation: :found, deactivated_at: nil) }

    it 'deactivates user and his/her registered pets' do
      deactivate_user
      lost_pet.reload
      found_pet.reload

      expect(user.deactivated_at).not_to be_nil
      expect(lost_pet.deactivated_at).not_to be_nil
      expect(found_pet.deactivated_at).not_to be_nil
    end

    it 'redirects to the root page' do
      deactivate_user

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'PATCH/PUT #update' do
    context 'when user registered using email' do
      let(:user) { create(:user, provider: 'email', password: '123456') }

      context 'when current password is informed' do
        let(:params) do
          {
            user: {
              first_name: 'New name',
              current_password: '123456'
            }
          }
        end

        it 'updates the user' do
          expect do
            put user_registration_path, params: params
            user.reload
          end.to change(user, :first_name).from(user.first_name).to('New name')
        end

        it 'redirects to the root page' do
          put user_registration_path, params: params

          expect(response).to redirect_to(root_path)
        end
      end

      context 'when current password is not informed' do
        let(:params) do
          {
            user: {
              first_name: 'New name',
              current_password: ''
            }
          }
        end

        it 'does not update the user' do
          expect do
            put user_registration_path, params: params
            user.reload
          end.not_to change(user, :first_name)
        end

        it 'renders the page again' do
          put user_registration_path, params: params

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when user registered using oauth' do
      let(:user) { create(:user, provider: 'google_oauth2', uid: '123') }

      context 'when current password is not informed' do
        let(:params) do
          {
            user: {
              first_name: 'New name'
            }
          }
        end

        it 'updates the user' do
          expect do
            put user_registration_path, params: params
            user.reload
          end.to change(user, :first_name).from(user.first_name).to('New name')
        end

        it 'redirects to the root page' do
          put user_registration_path, params: params

          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end

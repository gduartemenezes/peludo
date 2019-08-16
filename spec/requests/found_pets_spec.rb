# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FoundPets', type: :request do
  let(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  let(:valid_attributes) do
    {
      pet: {
        city: 'City',
        state: 'State',
        country: 'Country'
      }
    }
  end
  let(:invalid_attributes) do
    {
      pet: {
        city: '',
        state: '',
        country: ''
      }
    }
  end

  before do
    user.confirm
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get found_pets_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get new_found_pet_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get found_pet_path(pet)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get edit_found_pet_path(pet)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new found pet' do
        expect do
          post found_pets_path, params: valid_attributes
        end.to change(Pet, :count).by(1)
      end

      it 'redirects to the found pets page' do
        post found_pets_path, params: valid_attributes

        expect(response).to redirect_to(found_pets_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new list' do
        expect do
          post found_pets_path, params: invalid_attributes
        end.not_to change(Pet, :count)
      end

      it 'renders the list form again' do
        post found_pets_path, params: invalid_attributes

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          pet: {
            name: 'New name'
          }
        }
      end

      it 'updates the requested list' do
        expect do
          put found_pet_path(pet), params: new_attributes
          pet.reload
        end.to change(pet, :name).from(pet.name).to('New name')
      end

      it 'redirects to the found pets page' do
        put found_pet_path(pet), params: new_attributes
        pet.reload

        expect(response).to redirect_to(found_pets_path)
      end
    end

    context 'with invalid params' do
      it 'does not update the pet' do
        old_name = pet.name
        put found_pet_path(pet), params: invalid_attributes
        pet.reload

        expect(pet.name).to eq(old_name)
      end

      it 'renders the found pet form again' do
        put found_pet_path(pet), params: invalid_attributes

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested pet register' do
      expect do
        delete found_pet_path(pet)
      end.to change(Pet, :count).by(-1)
    end

    it 'redirects to the found pets page' do
      delete found_pet_path(pet)

      expect(response).to redirect_to(found_pets_path)
    end
  end
end

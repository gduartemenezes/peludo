# frozen_string_literal: true

module Api
  module V1
    class PetSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      belongs_to :breed

      attributes :id, :name, :age, :gender, :description,
                 :situation, :address, :latitude, :longitude,
                 :user_phone_number, :deactivated_at, :created_at,
                 :updated_at, :pictures

      def user_phone_number
        object.user.phone_number
      end

      def pictures
        object.pictures.zip(thumbnails).collect do |(original, thumbnail)|
          picture = {}
          picture['original'] = picture_json(original)
          picture['thumbnail'] = thumbnail ? picture_json(thumbnail) : {}
          picture
        end
      end

      private

      def thumbnails
        object.processed? ? object.thumbnails : []
      end

      def picture_json(object)
        {
          'id' => object.id,
          'url' => url_for(object)
        }
      end
    end
  end
end

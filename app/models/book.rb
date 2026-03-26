class Book < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy

  scope :alive, -> { where(discarded_at: nil) }
end

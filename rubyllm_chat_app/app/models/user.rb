# typed: false - Sorbet, if you use it later
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :chats, dependent: :destroy

  # Validations (Devise handles email/password, add one for name)
  #validates :name, presence: true, length: { minimum: 2 }
end

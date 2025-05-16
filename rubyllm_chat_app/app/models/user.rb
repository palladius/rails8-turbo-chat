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


  # if name given, good. If not, use email before domain instead.
  def name_or_email
    name.present? ?
      name :
      email.split('@')[0]
  end

end

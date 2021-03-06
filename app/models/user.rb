class User < ActiveRecord::Base
  has_many :wikis
  has_many :collaborators, dependent: :destroy
  before_save {self.email = email.downcase if email.present?}
  before_save {self.role ||= :standard}

  validates :name, length: {minimum: 1, maximum: 100}, presence: true
  validates :email, length: {minimum: 3, maximum: 254}, presence: true, uniqueness: {case_sensitve: false}
  validates :password, length: {minimum: 6}, presence: true, unless: :password_digest
  validates :password, length: {minimum: 6}, allow_blank: true

  has_secure_password

  enum role: [:standard, :premium, :admin]

  def downgrade
    self.standard!
  end

  def collaborator_to(wiki)
    collaborators.where(wiki_id: wiki.id).first
  end
end

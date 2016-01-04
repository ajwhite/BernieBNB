class User < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  validates :phone, length: { maximum: 16, minimum: 10, allow_nil: true }
  validates :first_name, presence: true, allow_nil: true
  validates :email, presence: true, allow_nil: true, uniqueness: true
  validates :uid, :session_token, presence: true, uniqueness: true
  validates_format_of :email,
    :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    allow_nil: true

  before_create :create_confirmation_token

  after_initialize :ensure_session_token

  has_many :visits, dependent: :destroy
  has_many :contacts, class_name: "Contact", foreign_key: :visitor_id
  has_many :contacted_host_listings, through: :contacts, source: :hosting
  has_many :contacted_hosts, through: :contacted_host_listings, source: :host

  has_many :hostings, class_name: "Hosting", foreign_key: :host_id, dependent: :destroy
  has_many :prospective_visitor_contacts, through: :hostings, source: :contacts
  has_many :prospective_visitors, through: :prospective_visitor_contacts, source: :visitor

  def self.generate_secure_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.create_with_omniauth(auth)
    if auth["info"]["email"]
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        user.email = auth["info"]["email"]
      end
    else
      create! do |user|
        user.provider = auth["provider"]
        user.uid = auth["uid"]
      end
    end
  end

  def phone=(number)
    number = number[1..-1] if number[0] == "1" # Alway remove leading "1".
    pnumber = number_to_phone(number.gsub(/\D/, ''), raise:true)
    if (pnumber.size != 12)
      raise ActiveRecord::RecordInvalid.new(self)
    else
      super(pnumber)
    end
  end

  def reset_session_token!
    self.session_token ||= self.class.generate_secure_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_secure_token
  end

  def create_confirmation_token
    self.confirm_token ||= self.class.generate_secure_token
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end
end

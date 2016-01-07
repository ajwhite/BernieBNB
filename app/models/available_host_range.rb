class AvailableHostRange < ActiveRecord::Base
  validates :start_date, :end_date, :hosting_id, presence: true
  validate :start_date_cannot_be_in_the_past, :end_date_comes_after_start_date, on: :create

  belongs_to :hosting

  # if this doesnt work, just write a method called create or update

  def save
    is_overlapping? ? merge_overlapping : super # super is used wrong here. take out the argument
  end

  def overlapping_date
    hosting.available_dates.where(":start_date <= end_date", start_date: start_date).where.not(id: id)
  end

  def is_overlapping?
    !overlapping_date.empty?
  end

  private

    def start_date_cannot_be_in_the_past
      errors.add(:start_date, "can't be in the past") unless start_date >= Date.today
    end

    def end_date_comes_after_start_date
      errors.add(:end_date, "can't come before the start") unless end_date - start_date >= 0
    end

    def merge_overlapping
      overlapping_date.first.update(end_date: end_date)
    end

end

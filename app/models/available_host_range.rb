class AvailableHostRange < ActiveRecord::Base
  validates :start_date, :end_date, :hosting_id, presence: true
  validate :start_date_cannot_be_in_the_past, :end_date_comes_after_start_date, on: :create

  belongs_to :hosting

  def self.create_or_update(start_date, end_date)
    date_range = AvailableHostRange.new(start_date: start_date, end_date: end_date)

    date_range.is_overlapping? ? date.merge_overlapping : date.save
  end

  def overlapping_date
    hosting.available_dates
      .where(":start_date <= end_date", start_date: start_date)
      .where("start_date <= :end_date", end_date: end_date)
      .where.not(id: id)
      .first
  end

  private

    def start_date_cannot_be_in_the_past
      errors.add(:start_date, "can't be in the past") unless start_date >= Date.today
    end

    def end_date_comes_after_start_date
      errors.add(:end_date, "can't come before the start") unless end_date - start_date >= 0
    end

    def is_overlapping?
      !overlapping_date.nil?
    end

    def merge_overlapping
      params = {}
      params[start_date] = start_date if start_date < overlapping_date.start_date
      params[end_date] = end_date if end_date > overlapping_date.end_date
      overlapping_date.update(end_date: end_date).update
    end

end

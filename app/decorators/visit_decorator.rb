class VisitDecorator < Draper::Decorator
  decorates :visit
  delegate_all

  def short_details
    starting = start_date.strftime("%m/%d")
    ending = end_date.strftime("%m/%d")

    "#{formatted_zip} (#{start_and_end_dates})"
  end

  def formatted_zip
    zipcode[0...5]
  end
end

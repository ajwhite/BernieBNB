class HostingDecorator < Draper::Decorator
  delegate_all

  def location
    city? && state? ? "#{city}, #{state.to_s}" : zipcode
  end

  def guest_details
    max_guests > 1 ? " #{max_guests} guests" : " #{max_guests} guest"
  end
end

class UserMailer < ApplicationMailer
  default from: "berniebnb@berniebnb.com"

  def welcome_email(user)
    @user = user
    @url = user_url(@user)
    mail(to: @user.email, subject: 'Welcome to BernieBNB')
  end

  def new_host_email(visit, hosting)
    @visit, @hosting, @visitor, @host = visit, hosting, visit.user, hosting.user
    @results_url = visit_url(@visit)
    mail(to: @visitor.email, subject: 'BernieBNB - New hosts available for you!')
  end

  def contact_host_email(visit, hosting)
    @visit, @hosting, @visitor, @host = visit, hosting, visit.user, hosting.user
    @hosting_url = hosting_url(@hosting)
    mail(to: @host.email, subject: "BernieBNB - You've been contacted!")
  end
end

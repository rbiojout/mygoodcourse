# Preview all emails at http://localhost:3000/rails/mailers/abuse_mailer
class AbuseMailerPreview < ActionMailer::Preview

  def received_en
    abuse = Abuse.last
    I18n.locale = 'en'
    AbuseMailer.received(abuse)
  end

  def received_fr
    abuse = Abuse.first
    I18n.locale = 'fr'
    AbuseMailer.received(abuse)
  end

  def accepted_en
    abuse = Abuse.first
    I18n.locale = 'en'
    AbuseMailer.accepted(abuse)
  end

  def accepted_fr
    abuse = Abuse.first
    I18n.locale = 'fr'
    AbuseMailer.accepted(abuse)
  end

  def rejected_en
    abuse = Abuse.first
    I18n.locale = 'en'
    AbuseMailer.rejected(abuse)
  end

  def rejected_fr
    abuse = Abuse.first
    I18n.locale = 'fr'
    AbuseMailer.rejected(abuse)
  end
end

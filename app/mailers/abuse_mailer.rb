class AbuseMailer < ApplicationMailer
  helper :abuses
  def received(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('mailer.abuse_mailer.received.subject', default: 'Abuse Confirmation')
  end

  def accepted(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('mailer.abuse_mailer.accepted.subject', default: 'Abuse Accepted')
  end

  def rejected(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('mailer.abuse_mailer.rejected.subject', default: 'Abuse Rejected')
  end
end

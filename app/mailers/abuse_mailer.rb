class AbuseMailer < ApplicationMailer
  def received(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('abuse_mailer.received.subject', default: 'Abuse Confirmation')
  end

  def accepted(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('abuse_mailer.accepted.subject', default: 'Abuse Accepted')
  end

  def rejected(abuse)
    @abuse = abuse
    mail to: abuse.customer.email, subject: I18n.t('abuse_mailer.rejected.subject', default: 'Abuse Rejected')
  end
end

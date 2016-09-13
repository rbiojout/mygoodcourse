class Abuse < ActiveRecord::Base
  # polymorphic association
  belongs_to :abusable, polymorphic: true

  # customer that report the abuse
  belongs_to :customer

  validates :description, presence: true

  scope :created,       ->{ where(status: 'created')  }
  scope :received,   ->{ where(status: 'received')  }
  scope :accepted,   ->{ where(status: 'accepted')  }
  scope :rejected,   ->{ where(status: 'rejected')  }
  scope :corrected,   ->{ where(status: 'corrected')  }

  # State Machine
  include AASM

  aasm :column => 'status' do
    state :created, :initial => true
    state :received, :accepted, :rejected, :corrected

    event :receive do
      before do
        logger.debug('Preparing to receive')
      end
      transitions :from => :created, :to => :received, :after => :sendReceivedEmail
    end

    event :accept do
      transitions :from => :received, :to => :accepted, :after => :sendAcceptedEmail
    end

    event :reject do
      transitions :from => :received, :to => :rejected, :after => :sendRejectedEmail
    end

    event :correct do
      transitions :from => :accepted, :to => :corrected
    end

    event :cancel do
      transitions :from => [:accepted, :rejected], :to => :created
    end
  end

  # send email Received
  def sendReceivedEmail
    # Tell the AbuseMailer to send a confirmation after save
    AbuseMailer.received(self).deliver_later
  end

  # send email Accepted
  def sendAcceptedEmail
    # Tell the AbuseMailer to send a confirmation after save
    AbuseMailer.accepted(self).deliver_later

  end

  # send email Rejected
  def sendRejectedEmail
    # Tell the AbuseMailer to send a confirmation after save
    AbuseMailer.rejected(self).deliver_later

  end

end
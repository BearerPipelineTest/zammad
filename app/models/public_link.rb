# Copyright (C) 2012-2022 Zammad Foundation, https://zammad-foundation.org/

class PublicLink < ApplicationModel
  include CanPriorization
  include ChecksClientNotification

  validates :link,      presence: true, length: { maximum: 500 }
  validates :title,     presence: true, length: { maximum: 200 }
  validates :screen, presence: true, inclusion: { in: %w[login signup password_reset] }

  before_validation :check_link

  default_scope { order('prio ASC, id ASC') }

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  client_notification_send_type 'public'

  private

  def check_link
    return true if link.blank?

    uri = URI.parse(link)
    raise Exceptions::UnprocessableEntity, "Invalid link '#{link}'." if !uri.is_a?(URI::HTTP)

    true
  end
end

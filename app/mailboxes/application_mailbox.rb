class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere
  # conversation-1234@example.com => ReplyMailbox
  routing ReplyMailbox::MATCHER => :reply
  
  # support@example.com => ConversationMailbox
  routing :all => :conversation

  def from
    @from ||= mail[:from].address_list.addresses.first
  end

  def author
    if (user = User.where(email: from.address))
      user
    else
      contact
    end
  end

  def contact
    contact = Contact.where(email: from.address).first_or_initialize
    contact.update name: from.display_name
    contact
  end

  def body
    if mail.multipart? && mail.html_part
      mail.html_part.body.decoded
    elsif mail.multipart? && mail.text_part
      mail.test_part.body.decoded
    else
      mail.decoded
    end
  end
end

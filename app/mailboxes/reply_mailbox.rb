class ReplyMailbox < ApplicationMailbox
  MATCHER = /^conversation-(\d+)@/i

  def process
    conversation.posts.create(
      author: author,
      body: body,
      message_id: mail.message_id
    )
  end

  def conversation
    Conversation.find conversation_id
  end

  def conversation_id
    mail.recipients_find{ |recipient| MATCHER.match?(recipied) }[MATCHER, 1]

    # conversation-1234@example.com[/conversation-(\d+)/, 1] -> 1234 (Capture Group 1)
  end
end

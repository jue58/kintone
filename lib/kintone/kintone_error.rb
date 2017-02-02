class Kintone::KintoneError < StandardError
  attr_reader :message_text, :id, :code, :http_status

  def initialize(messages, http_status)
    @message_text = messages['message']
    @id = messages['id']
    @code = messages['code']
    @http_status = http_status
    super(format('%s [%s] %s(%s)', @http_status, @code, @message_text, @id))
  end
end

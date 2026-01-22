class BrowserConstraint
  def initialize(allow_firefox:)
    @allow_firefox = allow_firefox
  end

  def matches?(request)
    is_firefox = request.user_agent.to_s.match?(/Firefox/i)
    @allow_firefox ? is_firefox : !is_firefox
  end
end

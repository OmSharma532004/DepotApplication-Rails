module AppConstants
  EMAIL_REGEX = /\A[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\z/

  LOCALE_MAP = {
    "english" => :en,
    "hindi"   => :hi,
    "spanish" => :es
  }.freeze
end

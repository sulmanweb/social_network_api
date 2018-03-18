class ApplicationMailer < ActionMailer::Base
  default from: DEFAULT_MAILER
  layout 'mailer'
end

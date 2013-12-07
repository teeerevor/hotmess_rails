class SendMailer

  def self.send_first_save_msg(short_list)
    body = save_text(short_list)
    send_email(short_list.email, body)
  end

  def self.send_shortlist
  end

  def self.send_email(to, body)
    to = 't@trev.io' if PADRINO_ENV == "development"
    subject = 'Your short list - hottest100.io'
    Pony.mail(to: to, from: 'trev@hottest100.io', subject: subject, body: body)
  end

  def self.send_text
%|Here is your Hottest 100 short list.

?

To view your shortlist on hottest100.io
go to <a href='hottest100.io/?'>hottest100.io/?</a>
|
  end
  
  def self.save_text(short_list)
    email = short_list.email
    puts email
    sl_text = short_list.format_list_as_text
%|Hi,

Awesome your short list is saved

Go here hottest100.io/#{email}
to get back to your short list in future.

Here is your current Hottest 100 short list.

#{sl_text}

Thanks for using hottest100.io

Trev

|
  end
end

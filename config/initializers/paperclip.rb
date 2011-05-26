Paperclip.interpolates :year do |attachment, style|
  attachment.instance.created_at.year
end
Paperclip.interpolates :month do |attachment, style|
  attachment.instance.created_at.month
end
Paperclip.interpolates :day do |attachment, style|
  attachment.instance.created_at.day
end
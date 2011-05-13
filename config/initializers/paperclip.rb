Paperclip.interpolates :year do |attachment, style|
  attachment.instance.updated_at.year
end
Paperclip.interpolates :month do |attachment, style|
  attachment.instance.updated_at.month
end
Paperclip.interpolates :day do |attachment, style|
  attachment.instance.updated_at.day
end
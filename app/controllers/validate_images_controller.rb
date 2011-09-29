class ValidateImagesController < ApplicationController
  def genvi
    validate_image = ValidateImage.new(4)
    session[:vicode] = validate_image.code
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end
end


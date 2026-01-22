class UserMailer < ApplicationMailer
  before_action :set_user, :set_order
  around_action :switch_locale

  def send_order_confirmation
    @line_items = @order.line_items.includes(
      product: { images_attachments: :blob }
    )
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid.to_s
    attach_product_images
    mail(
      to: @user.email,
      subject: "Order Confirmation ##{@order.id}"
    )
  end

  private

  def set_user
    @user = params[:user]
  end

  def set_order
    @order = params[:order]
  end

  def switch_locale(&action)
    locale = AppConstants::LOCALE_MAP[@user.language] || I18n.default_locale
    I18n.with_locale(locale,&action)
  end

  def attach_product_images
    @line_items.each do |item|
      product = item.product
      next unless product.images.attached?

      images = product.images
      first_image = images.first
      attachments.inline[first_image.filename.to_s] = {
        mime_type: first_image.content_type,
        content: first_image.download
      }
      images.drop(1).each do |image|
        attachments[image.filename.to_s] = {
          mime_type: image.content_type,
          content: image.download
        }
      end
    end
  end
end

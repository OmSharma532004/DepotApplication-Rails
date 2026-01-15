class UserMailer < ApplicationMailer
  def send_order_confirmation
    @user  = params[:user]
    @order = params[:order]

    @line_items = @order.line_items.includes(
      product: { images_attachments: :blob }
    )

    attach_product_images

    mail(
      to: @user.email,
      subject: "Order Confirmation ##{@order.id}"
    )
  end

  private

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

namespace :user do
  desc "Send order confirmation emails for all users and their orders"
  task send_order_confirmations: :environment do
    User.includes(:orders).find_each do |user|
      user.orders.find_each do |order|
        UserMailer.with(user: user, order: order)
                  .send_order_confirmation
                  .deliver_later
      end
    end
  end
end

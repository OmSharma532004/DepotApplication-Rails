namespace :user do
  desc "Make ALL users admin"
  task make_all_admin: :environment do
    count = User.update_all(role: 'admin')

    puts "✅ #{count} users have been promoted to admin"
  end
end

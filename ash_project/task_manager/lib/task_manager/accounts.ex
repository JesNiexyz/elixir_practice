defmodule TaskManager.Accounts do
  use Ash.Domain, otp_app: :task_manager, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource(TaskManager.Accounts.Token)

    resource TaskManager.Accounts.User do
      define(:register_user,
        action: :register_with_password,
        args: [:email, :password, :password_confirmation]
      )

      define(:list_users, action: :read)
      define(:get_user_by_email, action: :get_by_email, args: [:email])
    end
  end
end

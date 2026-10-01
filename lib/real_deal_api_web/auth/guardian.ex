defmodule RealDealApiWeb.Auth.Guardian do
  use Guardian, otp_app: :real_deal_api
  alias RealDealApi.Accounts #Access to accounts context file, insert and query for accounts

  #convert id for a string  and return it in a string form
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided} #return error for no id provided
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do # use account id to return resource being the account object
      nil -> {:error, :not_found} # no id associated with an account object
      resource -> {:ok, resource} # id associated with account object
    end
  end

  def resource_from_claims(_claims) do #no id provided
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil -> {:error, :unauthorized}
      account ->
        case validate_password(password, account.hash_password) do
          true -> create_token(account)
            false -> {:error, :unauthroized}
        end
    end
  end

  defp validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end
end

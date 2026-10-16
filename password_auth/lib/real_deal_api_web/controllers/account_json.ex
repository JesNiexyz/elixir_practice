defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    %{data: data(account)}
  end

  def create(%{account: account, token: token}) do
  %{
    data: %{
      id: account.id,
      email: account.email,
      token: token
    }
  }
end

def full_account(%{account: account}) do
  %{
    data: %{
      id: account.id,
      email: account.id,
      user: %{
        id: account.user.id,
        full_name: account.user.full_name,
        gender: account.user.gender,
        biography: account.user.biography
      }
    }
  }
end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      hash_password: account.hash_password
    }
  end
end

defmodule LetsRaid.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias LetsRaid.Repo

  alias LetsRaid.Players.{Player, PlayerToken, PlayerNotifier}

  ## Database getters

  @doc """
  Gets a player by email.

  ## Examples

      iex> get_player_by_email("foo@example.com")
      %Player{}

      iex> get_player_by_email("unknown@example.com")
      nil

  """
  def get_player_by_email(email) when is_binary(email) do
    Repo.get_by(Player, email: email)
  end

  def list_players() do
    Repo.all(Player)
  end

  @doc """
  Gets a player by email and password.

  ## Examples

      iex> get_player_by_email_and_password("foo@example.com", "correct_password")
      %Player{}

      iex> get_player_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_player_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    player = Repo.get_by(Player, email: email)
    if Player.valid_password?(player, password), do: player
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  ## Player registration

  @doc """
  Registers a player.

  ## Examples

      iex> register_player(%{field: value})
      {:ok, %Player{}}

      iex> register_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_player(attrs) do
    %Player{}
    |> Player.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player_registration(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player_registration(%Player{} = player, attrs \\ %{}) do
    Player.registration_changeset(player, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the player email.

  ## Examples

      iex> change_player_email(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player_email(player, attrs \\ %{}) do
    Player.email_changeset(player, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_player_email(player, "valid password", %{email: ...})
      {:ok, %Player{}}

      iex> apply_player_email(player, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_player_email(player, password, attrs) do
    player
    |> Player.email_changeset(attrs)
    |> Player.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the player email using the given token.

  If the token matches, the player email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_player_email(player, token) do
    context = "change:#{player.email}"

    with {:ok, query} <- PlayerToken.verify_change_email_token_query(token, context),
         %PlayerToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(player_email_multi(player, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp player_email_multi(player, email, context) do
    changeset =
      player
      |> Player.email_changeset(%{email: email})
      |> Player.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:player, changeset)
    |> Ecto.Multi.delete_all(:tokens, PlayerToken.player_and_contexts_query(player, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given player.

  ## Examples

      iex> deliver_player_update_email_instructions(player, current_email, &url(~p"/players/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_player_update_email_instructions(
        %Player{} = player,
        current_email,
        update_email_url_fun
      )
      when is_function(update_email_url_fun, 1) do
    {encoded_token, player_token} =
      PlayerToken.build_email_token(player, "change:#{current_email}")

    Repo.insert!(player_token)
    PlayerNotifier.deliver_update_email_instructions(player, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the player password.

  ## Examples

      iex> change_player_password(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player_password(player, attrs \\ %{}) do
    Player.password_changeset(player, attrs, hash_password: false)
  end

  @doc """
  Updates the player password.

  ## Examples

      iex> update_player_password(player, "valid password", %{password: ...})
      {:ok, %Player{}}

      iex> update_player_password(player, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_password(player, password, attrs) do
    changeset =
      player
      |> Player.password_changeset(attrs)
      |> Player.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:player, changeset)
    |> Ecto.Multi.delete_all(:tokens, PlayerToken.player_and_contexts_query(player, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{player: player}} -> {:ok, player}
      {:error, :player, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_player_session_token(player) do
    {token, player_token} = PlayerToken.build_session_token(player)
    Repo.insert!(player_token)
    token
  end

  @doc """
  Gets the player with the given signed token.
  """
  def get_player_by_session_token(token) do
    {:ok, query} = PlayerToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_player_session_token(token) do
    Repo.delete_all(PlayerToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given player.

  ## Examples

      iex> deliver_player_confirmation_instructions(player, &url(~p"/players/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_player_confirmation_instructions(confirmed_player, &url(~p"/players/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_player_confirmation_instructions(%Player{} = player, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if player.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, player_token} = PlayerToken.build_email_token(player, "confirm")
      Repo.insert!(player_token)

      PlayerNotifier.deliver_confirmation_instructions(
        player,
        confirmation_url_fun.(encoded_token)
      )
    end
  end

  @doc """
  Confirms a player by the given token.

  If the token matches, the player account is marked as confirmed
  and the token is deleted.
  """
  def confirm_player(token) do
    with {:ok, query} <- PlayerToken.verify_email_token_query(token, "confirm"),
         %Player{} = player <- Repo.one(query),
         {:ok, %{player: player}} <- Repo.transaction(confirm_player_multi(player)) do
      {:ok, player}
    else
      _ -> :error
    end
  end

  defp confirm_player_multi(player) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:player, Player.confirm_changeset(player))
    |> Ecto.Multi.delete_all(:tokens, PlayerToken.player_and_contexts_query(player, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given player.

  ## Examples

      iex> deliver_player_reset_password_instructions(player, &url(~p"/players/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_player_reset_password_instructions(%Player{} = player, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, player_token} = PlayerToken.build_email_token(player, "reset_password")
    Repo.insert!(player_token)

    PlayerNotifier.deliver_reset_password_instructions(
      player,
      reset_password_url_fun.(encoded_token)
    )
  end

  @doc """
  Gets the player by reset password token.

  ## Examples

      iex> get_player_by_reset_password_token("validtoken")
      %Player{}

      iex> get_player_by_reset_password_token("invalidtoken")
      nil

  """
  def get_player_by_reset_password_token(token) do
    with {:ok, query} <- PlayerToken.verify_email_token_query(token, "reset_password"),
         %Player{} = player <- Repo.one(query) do
      player
    else
      _ -> nil
    end
  end

  @doc """
  Resets the player password.

  ## Examples

      iex> reset_player_password(player, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Player{}}

      iex> reset_player_password(player, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_player_password(player, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:player, Player.password_changeset(player, attrs))
    |> Ecto.Multi.delete_all(:tokens, PlayerToken.player_and_contexts_query(player, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{player: player}} -> {:ok, player}
      {:error, :player, changeset, _} -> {:error, changeset}
    end
  end

  alias LetsRaid.Players.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end

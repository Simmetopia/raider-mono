defmodule LetsRaid.Plugs.AuthPlug do
  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    conn.req_headers |> dbg
    conn
  end
end

defmodule PartygoWeb.Plug.VerifyCSRF do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 2]
  alias Plug.Conn.Cookies

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, cookie_token} <- get_cookie_token(conn),
         {:ok, body_token}   <- get_body_token(conn),
         true <- (cookie_token == body_token) do
      conn
    else 
      _ -> bad_request(conn)
    end
  end

  defp get_cookie_token(conn) do
    with [cookies] <- get_req_header(conn, "cookie"),
         %{"g_csrf_token" => csrf_token} <- Cookies.decode(cookies) do
      {:ok, csrf_token}
    else
      _ -> {:error, :invalid_cookie}
    end
  end

  defp get_body_token(%Plug.Conn{body_params: %{"g_csrf_token" => csrf_token}}),
    do: {:ok, csrf_token}
  defp get_body_token(_conn), do: {:error, :invalid_body}

  defp bad_request(conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(PartygoWeb.ErrorView)
    |> render("400.json")
    |> halt
  end
end

FROM elixir:1.12.3-alpine

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix deps.get && mix phx.server
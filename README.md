# Niesso

This module is an attempt to implement a basic SAML service provider library
tailored specifically for a project authenticating users for the National
Institute of Education in Singapore.

Authentication services are provided by a SAML identity provider, but we had
difficulty integrating existing Elixir/Erlang SAML libraries with this identity
provider so this library was created as an attempt to manage that complexity.

In time this may become a proper SAML library, but currently it is a tiny
slice of a full SAML library that is tailored specifically for our needs and
as such unlikely to be of any use to anyone else.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `niesso` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:niesso, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/niesso](https://hexdocs.pm/niesso).

## API

Currently the API I propose to expose from this library is very simple.

```elixir
case Niesso.consume_auth_resp(response) do
  {:ok, assertion} ->
    # use the assertion to read the attributes of the user
  {:error, reason} ->
    # handle the error casek
end
```

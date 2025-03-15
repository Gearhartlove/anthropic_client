defmodule AnthropicClient do
  @moduledoc """
  A client for interacting with Anthropic's Claude API using the Req HTTP library.
  """

  @base_url "https://api.anthropic.com/v1"
  @default_model "claude-3-haiku-20240307"
  @default_max_tokens 1024

  @doc """
  Creates a new message using Anthropic's Messages API.

  ## Parameters
    * api_key - Your Anthropic API key
    * messages - List of message maps with role and content keys
    * model - Model to use (default: claude-3-7-sonnet-20250219)
    * max_tokens - Maximum number of tokens to generate (default: 1024)
    * system - Optional system prompt
    * temperature - Optional temperature setting (0.0-1.0)
    * top_p - Optional top_p setting
    * top_k - Optional top_k setting
    * metadata - Optional metadata map

  ## Examples

      AnthropicClient.create_message(
        "your-api-key",
        [
          %{role: "user", content: "Hello, Claude!"}
        ]
      )
  """
  def create_message(messages, opts \\ []) do
    api_key = System.get_env("ANTHROPIC_API_KEY")
    model = Keyword.get(opts, :model, @default_model)
    max_tokens = Keyword.get(opts, :max_tokens, @default_max_tokens)
    system = Keyword.get(opts, :system)
    temperature = Keyword.get(opts, :temperature)
    top_p = Keyword.get(opts, :top_p)
    top_k = Keyword.get(opts, :top_k)
    metadata = Keyword.get(opts, :metadata)

    # Build the request payload
    payload = %{
      model: model,
      messages: messages,
      max_tokens: max_tokens
    }

    # Add optional parameters if provided
    payload = if system, do: Map.put(payload, :system, system), else: payload
    payload = if temperature, do: Map.put(payload, :temperature, temperature), else: payload
    payload = if top_p, do: Map.put(payload, :top_p, top_p), else: payload
    payload = if top_k, do: Map.put(payload, :top_k, top_k), else: payload
    payload = if metadata, do: Map.put(payload, :metadata, metadata), else: payload

    # Make the API request
    Req.post(
      "#{@base_url}/messages",
      json: payload,
      headers: [
        {"x-api-key", api_key},
        {"anthropic-version", "2023-06-01"},
        {"content-type", "application/json"}
      ]
    )
  end
end

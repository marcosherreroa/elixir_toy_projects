defmodule DiscussWeb.TopicHTML do
  @moduledoc """
  This module contains pages rendered by TopicController.

  See the `topic_html` directory for all templates available.
  """
  use DiscussWeb, :html
  #import Phoenix.HTML.Form

  embed_templates "topic_html/*"
end

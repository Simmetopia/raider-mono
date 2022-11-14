defmodule LetsRaidWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("404.json", _assigns) do
    %{errors: %{detail: "The resource you are looking for does not exists"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Something went wrong on our end. Please contact someone"}}
  end
end

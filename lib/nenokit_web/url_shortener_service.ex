defmodule NenokitWeb.URLShortenerService do

  defmacro __using__(_) do
    quote do
      require IEx

      def shorten(url) do
        current_module = __MODULE__
        host_action = current_module.host <> current_module.action

        response = 
          case current_module.method do
            "get" ->
              HTTPotion.get(host_action <> "?" <> current_module.param <> "=" <> url)
            "post" ->
              HTTPotion.post(host_action, [body: current_module.param <> "=" <> url])
            _ ->
              spawn_link fn -> exit("Invalid method '#{current_module.method}'") end
          end
        
        if response.status_code == current_module.code do
          current_module.on_response(response)
        else
          on_error(response)
        end
      end

      def on_error(response) do
        raise "error shorting url for #{__MODULE__}: #{response.body}"
      end

    end
  end
end
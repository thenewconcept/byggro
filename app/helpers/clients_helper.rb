module ClientsHelper
  def uid(client)
    client.nid.presence || "##{client.id}"
  end
end

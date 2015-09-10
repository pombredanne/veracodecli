
def prescan_poller(app_id)
  prescan_results = `veracodeapi get_prescan_results #{app_id}`
end

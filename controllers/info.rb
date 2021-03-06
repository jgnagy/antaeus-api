# The info Controller

# @!group Informational Public Routes

# GET the current version of the application
get '/info/version' do
  api_action do
	  body({api: {:version => APP_VERSION}}.to_json)
  end
end

# GET the current status of the application
get '/info/status' do
  api_action do
	  body({api: {:status => :available}}.to_json)
  end
end

# TODO: define more capabilities throughout and report on them here
get '/info/capabilities' do
  api_action do
    body(
      {
        api: {
          capabilities: Capabilities.instance.to_hash,
        }
      }.to_json
    )
  end
end

# All the plugins installed on the system, plus their config properties
get '/info/plugins' do
  api_action do
    body(
      {
        api: {
          plugins: Plugins.instance.to_hash
        }
      }.to_json
    )
  end
end

# Might want to add auth to this eventually...
get '/info/metrics' do
  api_action do
    body({api: {metrics: Metrics.to_hash}}.to_json)
  end
end

# GET details about the currently logged-in user
get '/info/me' do
  api_action do
    if api_authenticated?
      body({
        current_user: {
          login: @current_user.to_s,
          admin: @current_user.admin?
        }
      }.to_json)
    else
      body({current_user: nil}.to_json)
    end
  end
end

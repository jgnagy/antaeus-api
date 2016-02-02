# The groups Controller

api_parse_for(:groups)

# @!group Public Routes

# GET the groups known to the application
get '/groups.json' do
  begin
    expires 300
    if api_authenticated? && @current_user.admin?
      status 200
    	body(Group.all.collect {|g| g.to_s }.to_json)
    else
      fail "Insufficient Privileges"
    end
  rescue => e
    fail e
    halt(422, { :error => e.message }.to_json)
  end
end

# GET the members of a group
get '/groups/:group/members.json' do
  begin
    expires 300
    if api_authenticated? && @current_user.admin?
      status 200
    	body(Group.from_attr(params['group']).members.collect {|m| m.to_s }.to_json)
    else
      fail "Insufficient Privileges"
    end
  rescue => e
    halt(422, { :error => e.message }.to_json)
  end
end
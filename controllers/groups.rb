# The groups Controller

api_parse_for(:groups)

# @!group Public Routes

# GET the groups known to the application
get '/groups' do
  begin
    if api_authenticated? && @current_user.admin?
      status 200
      body(
        if lazy_request?
          cache_fetch('all_group_json', expires: 300) { Group.all.serialize(only: :id) }
        else
          cache_fetch('full_all_group_json', expires: 300) { Group.all.serialize }
        end
      )
    else
      fail "Insufficient Privileges"
    end
  rescue => e
    halt(422, { :error => e.message }.to_json)
  end
end

# GET a Group search
get '/groups/search' do
  begin
    if api_authenticated? && @current_user.admin?
      status 200
    	body(
        if lazy_request?
          cache_fetch("search_group_#{params['q']}_json", expires: 300) do
            Group.search(params['q']).serialize(only: :id)
          end
        else
          cache_fetch("full_search_group_#{params['q']}_json", expires: 300) do
            Group.search(params['q']).serialize
          end
        end
      )
    end
  rescue => e
    halt(422, { :error => e.message }.to_json)
  end
end

# GET the details on a user
get '/groups/:group' do
  begin
    if api_authenticated? && @current_user.admin?
      status 200
    	body(
        Group.from_attr(params['group']).serialize(
          exclude: [
            CONFIG[:ldap][:memberattr].to_sym,
            :dn
          ]
        )
      )
    end
  rescue => e
    halt(422, { :error => e.message }.to_json)
  end
end

# GET the members of a group
get '/groups/:group/members' do
  begin
    if api_authenticated? && @current_user.admin?
      status 200
    	body(
        if lazy_request?
          cache_fetch("group_#{params['group']}_members_json", expires: 120) do
            Group.from_attr(params['group']).members.serialize(only: :id)
          end
        else
          cache_fetch("full_group_#{params['group']}_members_json", expires: 120) do
            Group.from_attr(params['group']).members.serialize
          end
        end
      )
    else
      fail "Insufficient Privileges"
    end
  rescue => e
    halt(422, { :error => e.message }.to_json)
  end
end

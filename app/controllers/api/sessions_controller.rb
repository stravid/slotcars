class Api::SessionsController < Devise::SessionsController
  
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "api/sessions#failure")
    sign_in(resource_name, resource)
  end

  def sign_in(resource_or_scope, resource=nil)
    scope      = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource

    # return authenticated user as JSON
    render :status => '200', :json => resource
  end

  def failure
    return render :nothing => true, :status => '401'
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))

    if signed_out
      render :nothing => true, :status => '200'
    else
      render :nothing => true, :status => '400'
    end
  end

end
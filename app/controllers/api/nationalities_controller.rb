class Api::NationalitiesController < ApiController
  before_action :authenticate_token!

  def index
    @nationalities = Nationality.list.sort_by {|k,v| v }
  end
end

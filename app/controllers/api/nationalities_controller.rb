class Api::NationalitiesController < ApiController

  def index
    @nationalities = Nationality.list.sort
  end
end

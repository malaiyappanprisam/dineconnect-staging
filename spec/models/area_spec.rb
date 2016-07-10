require 'rails_helper'

describe Area do
  it { should validate_presence_of(:name) }
end

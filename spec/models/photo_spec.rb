require 'rails_helper'

describe Photo do
  it { should belong_to(:photoable) }
end

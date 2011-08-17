require "spec_helper"

describe ApplicationController do
 specify { controller.should be_respond_to(:current_user) }

end

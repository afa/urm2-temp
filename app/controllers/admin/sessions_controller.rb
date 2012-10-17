class Admin::SessionsController < Admin::ApplicationController
 include Afauth::Controller::Session
 layout false
end

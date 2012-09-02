# coding: UTF-8
class SessionsController < ApplicationController
 include Afauth::Controller::Session
 skip_before_filter :check_account_cur, :except => :destroy
 skip_before_filter :get_accounts_in, :except => :destroy
 skip_before_filter :take_search
 
 #skip_before_filter :authenticate!, :only => [:new, :create]
 layout false

end

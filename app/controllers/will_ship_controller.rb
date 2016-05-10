class WillShipController < ApplicationController
  unloadable
  before_filter :require_admin, except: [:force_update]
  before_filter :find_harbor, only: [:edit, :destroy]

  def new
    @harbor = Harbor.new
    @projects = Project.all
  end

  def edit
  end

  def create
    harbor = Harbor.new params[:harbor]
    if harbor.save!
      flash[:notice] = 'New Harbor just created!'
      redirect_to action: 'configure'
    else
      flash[:error] = 'Error!'
      redirect_to :back
    end
  end

  def destroy
    if @harbor.destroy
      flash[:notice] = 'Removed!'
    else
      flash[:error] = 'Error!'
    end

    redirect_to action: 'configure'
  end

  def configure
    if WillShip.missing_custom_fields
      @custom_fields_list = WillShip.custom_fields_list
      render 'misconfiguration'
    else
      @harbors = Harbor.all
      render 'configure'
    end
  end

  def force_update
    issue = Issue.find params[:issue_id]
    return unless issue.present?
    issue.check_harbors!

    flash[:notice] = 'All Harbors checked! If we shipped we will see.'

    redirect_to :back
  end

  protected
  def find_harbor
    @harbor = Harbor.find params[:id]
  end
end
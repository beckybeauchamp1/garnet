class ObservationsController < ApplicationController

  def create
    @group = Group.at_path(params[:group_path])
    @user = User.find_by(username: params[:membership_user])
    @observation = current_user.admin_observations.new(observation_params)
    @observation.user_id = @user.id
    @observation.group_id = @group.id
    if @observation.save!
      redirect_to group_membership_path(@group, @user)
    end
  end

  private
  def observation_params
    params.require(:observation).permit(:body, :status)
  end
end

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[destroy]

  # GET /notifications
  def index
    @notifications = Notification.all
    render json: NotificationBlueprint.render(@notifications)
  end

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      render json: NotificationBlueprint.render(@notification), status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notifications/1
  def destroy
    @notification.destroy
    render json: { message: 'Notification deleted' }, status: :ok
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.permit(:description, :user_id, :event_id, :talk_id)
  end
end

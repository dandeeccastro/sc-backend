class NotificationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, except: %i[talk]
  before_action :set_notification, only: %i[destroy]
  before_action :admin_or_staff?, only: %i[create destroy]

  def event
    notifications = Notification.where(event_id: @event.id)
    render json: NotificationBlueprint.render(notifications)
  end

  def talk
    notifications = Notification.where(talk_id: params[:talk_id])
    render json: NotificationBlueprint.render(notifications)
  end

  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      render json: NotificationBlueprint.render(@notification), status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

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

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end
end

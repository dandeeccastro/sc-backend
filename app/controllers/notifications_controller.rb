class NotificationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, except: %i[talk]
  before_action :set_notification, only: %i[update destroy]
  before_action :admin_or_staff?, only: %i[create update destroy]

  after_action :log_data, only: %i[create update destroy]

  def index
    talk_ids = Vacancy.joins(talk: [ :event ]).where(user_id: @current_user.id, event: { id: @event.id }).map(&:talk_id)
    notifications = Notification.where(event_id: @event.id, talk_id: nil).or(Notification.where(talk_id: talk_ids)).order(created_at: :desc)
    render json: NotificationBlueprint.render(notifications, view: :detailed)
  end

  def create
    @notification = Notification.new(notification_params.merge(user_id: @current_user.id))

    if @notification.save
      render json: NotificationBlueprint.render(@notification), status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      render json: NotificationBlueprint.render(@notification), status: :ok
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @notification.destroy
    render json: { message: 'Notificação deletada!' }, status: :ok
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.permit(:description, :user_id, :event_id, :talk_id, :title)
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end
end

class NotificationsController < ApplicationController
  before_action :authenticate_user

  before_action :set_event, except: %i[talk]
  before_action :set_notification, only: %i[update destroy]

  before_action only: %i[create update destroy] do
    set_permissions
    check_permissions(%i[admin staff_leader staff])
  end

  def index
    talk_ids = Vacancy.joins(talk: [ :event ]).where(user_id: @current_user.id, event: { id: @event.id }).map(&:talk_id)
    notifications = Notification.where(event_id: @event.id, talk_id: nil).or(Notification.where(talk_id: talk_ids)).order(created_at: :desc)
    render json: NotificationBlueprint.render(notifications, view: :detailed)
  end

  def staff
    notifications = Notification.where(event_id: @event.id).order(created_at: :desc)
    render json: NotificationBlueprint.render(notifications, view: :detailed)
  end

  def talk
    @notifications = Notification.where('talk_id = :talk_id', { talk_id: notification_params[:talk_id] })
    render json: NotificationBlueprint.render(@notifications)
  end

  def create
    @notification = Notification.new(notification_params)

    if @notification.save
      AuditLogger.log_message("#{@current_user} criou a notificação #{@notification.title}")
      render json: NotificationBlueprint.render(@notification, view: :detailed), status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification.update(notification_params)
      AuditLogger.log_message("#{@current_user} atualizou a notificação #{@notification.title}")
      render json: NotificationBlueprint.render(@notification, view: :detailed), status: :ok
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def destroy
    AuditLogger.log_message("#{@current_user} deletou a notificação #{@notification.title}")
    @notification.destroy
    render json: { message: 'Notificação deletada!' }, status: :ok
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.merge(user_id: @current_user.id, event_id: @event.id).permit(:description, :user_id, :event_id, :talk_id, :title)
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end
end

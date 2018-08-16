class Micropost < ApplicationRecord
  belongs_to :user
  scope :load_microposts, ->{order created_at: :desc}
  scope :feed, ->(id){where "user_id IN (?) OR user_id = ?", "%#{id}%"}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_max}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.picture_size.megabytes
      errors.add :picture, "#{I18n.t('microposts.model.less_than')}
        #{Settings.picture_size}MB"
    end
  end
end

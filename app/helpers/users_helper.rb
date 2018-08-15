module UsersHelper
  def gravatar_for user, options = {size: Settings.avatar_size}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def follow_user
    current_user.active_relationships.build
  end

  def find_followed_user
    current_user.active_relationships.find_by followed_id: @user.id
  end
end

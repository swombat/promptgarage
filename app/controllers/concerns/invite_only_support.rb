# Ejected from `bullet_train-1.7.4/app/controllers/concerns/invite_only_support.rb`.

module InviteOnlySupport
  extend ActiveSupport::Concern

  def invitation
    return not_found unless invitation_only?
    return not_found unless params[:key].present?
    return not_found unless InvitationKey.all.collect(&:key).include?(params[:key].strip)
    session[:invitation_key] = params[:key]
    if user_signed_in?
      redirect_to new_account_team_path
    else
      redirect_to new_user_registration_path
    end
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end

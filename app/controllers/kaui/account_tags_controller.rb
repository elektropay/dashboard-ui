class Kaui::AccountTagsController < Kaui::EngineController

  def edit
    @account_id = params.require(:account_id)
    @tag_names = (Kaui::Tag.all_for_account(@account_id, false, 'NONE', options_for_klient).map { |tag| tag.tag_definition_name }).sort
    @available_tags = Kaui::TagDefinition.all_for_account(options_for_klient)
  end

  def update
    account_id = params.require(:account_id)

    tags = []
    params.each do |tag, tag_name|
      tag_info = tag.split('_')
      next if tag_info.size != 2 or tag_info[0] != 'tag'
      tags << tag_info[1]
    end

    Kaui::Tag.set_for_account(account_id, tags, current_user.kb_username, params[:reason], params[:comment], options_for_klient)
    redirect_to kaui_engine.account_path(account_id), :notice => 'Account tags successfully set'
  end
end

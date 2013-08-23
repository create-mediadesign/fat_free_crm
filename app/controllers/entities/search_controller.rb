class SearchController < ApplicationController

  def new
    raise "Not yet implemented!"
    search = Search::Entity.new(params.delete(:entities))
    @auto_complete = search.search(params)
 
    #respond_to do |format|
    #  format.js   { render :partial => 'fulltext_auto_complete' }
    #end
  end

  def auto_complete
    search = Search::Entity.new(params.delete(:entities).try(:split,',') || [])
    @query = params[:query]
    @entities_count = search.entities.count
    @auto_complete = search.suggest(params.merge(:constraints => ['public', current_user.id]))

    respond_to do |format|
      format.js   { render :partial => 'fulltext_auto_complete' }
    end
  end

end
# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Search::Entity

  #----------------------------------------------------------------------------
  def initialize(entity_or_entities)
    #binding.pry
    @entities = (entity_or_entities.instance_of?(Array) ? entity_or_entities : [entity_or_entities]).map(&:to_sym).delete_if do |e|
      {
        :accounts => true,
        :campaigns => true,
        :contacts => true,
        :leads => true,
        :opportunities => true,
        :tasks => true
      }[e].nil?
    end
    raise "No valid entities found!" if @entities.empty?
  end

  #----------------------------------------------------------------------------
  def search(params)
    results = Tire.search entity_names, :load => false do
      query do
        string params[:query], default_operator: 'AND'
      end if params[:query].present?
      filter :terms, :_constraints => params[:constraints].map(&:to_s)
    end.results
    # FilteredResults.new(results)
    results
  end

  #----------------------------------------------------------------------------
  def suggest(params)
    params[:query] = params[:query].split(" ").map {|v| v+"*"}.join(" ")
    self.search(params)
  end

  #----------------------------------------------------------------------------
  def entities
    @entities
  end

  private
  def entity_names
    @entities
  end

end


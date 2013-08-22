# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
namespace :ffcrm do
  namespace :search do

    desc "Reindex everything (elasticsearch)"
    task :reindex => :environment do
      print "Indexing ("
      print "Account"
      Account.searchable_reindex!
      print ", Campaign"
      Campaign.searchable_reindex!
      print ", Contact"
      Contact.searchable_reindex!
      print ", Lead"
      Lead.searchable_reindex!
      print ", Opportunity"
      Opportunity.searchable_reindex!
      print ", Task) ..."
      Task.searchable_reindex!
      puts " [done]"
    end
    
  end
end
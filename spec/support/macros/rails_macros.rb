module RailsMacros
  def relation_class(klass)
    if ActiveRecord::VERSION::MAJOR == 3
      ActiveRecord::Relation
    else
      ActiveRecord::AssociationRelation
    end
  end
end

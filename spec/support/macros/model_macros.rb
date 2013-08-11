module ModelMacros
  # Create a new organization model
  def spawn_organization_model(klass_name = 'Organization', &block)
    spawn_model klass_name, ActiveRecord::Base do
      acts_as_organization
      instance_exec(&block) if block
    end
  end

  # Create a new user model
  def spawn_user_model(klass_name = 'User', &block)
    spawn_model klass_name, ActiveRecord::Base do
      acts_as_user
      instance_exec(&block) if block
    end
  end

  def spawn_membership_model(klass_name = 'Membership', &block)
    spawn_model 'Membership', ActiveRecord::Base do
      acts_as_membership
      instance_exec(&block) if block
    end
  end

  protected

  # Create a new model class
  def spawn_model(klass_name, parent_klass, &block)
    Object.instance_eval { remove_const klass_name } if Object.const_defined?(klass_name)
    @spawned_models << Object.const_set(klass_name, Class.new(parent_klass))
    Object.const_get(klass_name).class_eval(&block) if block_given?
  end
end

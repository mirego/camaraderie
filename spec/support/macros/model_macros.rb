module ModelMacros
  # Create a new emotional model
  def organization(klass_name, &block)
    spawn_model klass_name, ActiveRecord::Base do
      acts_as_organization
      instance_exec(&block) if block
    end
  end

  # Create a new emotive model
  def user(klass_name, &block)
    spawn_model klass_name, ActiveRecord::Base do
      acts_as_user
      class_eval(&block) if block
    end
  end

  protected

  # Create a new model class
  def spawn_model(klass_name, parent_klass, &block)
    Object.instance_eval { remove_const klass_name } if Object.const_defined?(klass_name)
    Object.const_set(klass_name, Class.new(parent_klass))
    Object.const_get(klass_name).class_eval(&block) if block_given?
  end
end

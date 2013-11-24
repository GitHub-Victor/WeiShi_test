module NestedResourceHelper
  def self.get_nested_resource_list(targets)
    name_list = []
    targets.each_with_index do |target,index|
        name_list << target.name
    end
    name_list.join ','
  end
end
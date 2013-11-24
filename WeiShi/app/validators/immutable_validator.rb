# -*- encoding : utf-8 -*-
class ImmutableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 假如属性已改变，并且之前不为空，并且不是新纪录，就抛出错误
    if record.send("#{attribute}_changed?") && !record.send("#{attribute}_was").blank? &&!record.new_record?
      record.errors.add attribute, :immutable
    end
  end
end

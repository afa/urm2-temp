module MainHelper
 def to_bool(val)
  ActiveRecord::ConnectionAdapters::Column.value_to_boolean(val)
 end
end

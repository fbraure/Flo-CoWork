module FormHelper
  def enum_translated_for(model, enum_name, enum_value)
    get_translations(model, enum_name, enum_value)
  end

  def enum_collection_translated_for(model, enum_name)
    get_translations(model, enum_name).map { |key, value| [value, key.to_s] }.to_h
  end

  def limited_enum_collection_translated_for(model, enum_name, keys_to_exclude)
    get_translations(model, enum_name).except(*keys_to_exclude).map { |key, value| [value, key.to_s] }.to_h
  end

  def custom_collection_translated_for(model, custom_collection_name)
    get_translations(model, custom_collection_name).map { |key, value| [value, key.to_s] }.to_h
  end

  private

  def get_translations(parent_key, child_key, enum_value="")
    t("activerecord.attributes.#{parent_key}.#{child_key}#{".#{enum_value}" if enum_value.present? }")
  end
end

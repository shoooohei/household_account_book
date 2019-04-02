module BadgetsHelper
  # 予算が未入力のカテゴリを抽出
  def make_left_categories(categories)
    all_categories = Hash.new
    categories.each do |category|
      all_categories[category.kind] = category.id
    end
    left_categories = all_categories
    unless Badget.find_by(user_id: current_user.id).present?
      return left_categories
    end
    badgets = current_user.badgets
    badget_categories = Array.new
    badgets.each do |badget|
      category = badget.category.kind
      badget_categories << category
    end

    badget_categories.each do |category_kind|
      left_categories.delete(category_kind)
    end

    return left_categories
  end

  # @param [Badget] badgets
  # @return [String]
  def badgets_sum(badgets)
    if badgets
      badgets.map(&:amount).sum.to_s(:delimited)
    else
      "0"
    end
  end

  # @param [Category] category
  # @return [Boolean]
  def category_has_current_user_badget?(badget)
    badget.try(:user_id) == current_user.id
  end

end

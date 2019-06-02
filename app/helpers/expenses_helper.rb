# 出費一覧・入力画面で使うヘルパー
module ExpensesHelper

  def index_page_tile
    @period.to_japanese_period + "の出費の履歴"
  end

  # 前月の出費履歴ページへ遷移するボタン
  def to_expenses_last_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-left")
    if params[:period]
      period = params[:period].to_last_period
    else
      period = Date.current.to_s_as_period.to_last_period
    end
    link_to icon,  expenses_path(period: period), class: "btn btn-orange col-xs-2 text-center", id: "last-month-btn"
  end

  # 来月の出費履歴ページへ遷移するボタン
  def to_expenses_next_month_btn
    icon = tag.i(class: "fa fa-lg fa-angle-double-right")
    if params[:period]
      period = params[:period].to_next_period
    else
      period = Date.current.to_s_as_period.to_next_period
    end
    link_to icon, expenses_path(period: period), class: "btn btn-orange col-xs-2 text-center space-right", id: "next-month-btn"
  end

  def category_selection_without_only_partner_own
    categories_without_only_partner_own.map{ |c| [c.name, c.id] }
  end

  def back_btn_to_analyses_page
    link_to '分析へ', analyses_path(analyses_params), class: "btn btn-brown space-bottom"
  end

  def expenses_list_params
    {
      period: session['expenses_list_params']['period'],
      category: session['expenses_list_params']['category'],
      expense: @expense.id
    }
  end

  def back_btn_to_expenses_list
    link_to '出費履歴へ', expenses_path(expenses_list_params), class: "btn btn-brown space-bottom"
  end

  def analyses_params
    parameters = {}
    conditions = %w(period tab category)
    analyses_params = session['analyses_params']
    analyses_params.each do |key, value|
      if conditions.include?(key)
        parameters[key.to_sym] = value
      end
    end
    parameters
  end

  def expenses_without_only_partner_own
    @expenses.reject{ |e| e.is_own_expense?(@partner) }
  end

  # 出費入力のときに割合の選択肢
  def percent_selection
    Expense.percents.map do |k, v|
      next if k == "manual_amount"
      [t("activerecord.enum.expense.percent.#{k}"), v]
    end.compact
  end

end

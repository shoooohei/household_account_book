class Expense < ApplicationRecord
  belongs_to :user
  has_one :category
  validates :amount, :date, presence: true
  validate :calculate_amount
  def calculate_amount
    if mypay != nil && partnerpay != nil && mypay + partnerpay != amount
      errors[:base] << "入力した金額の合計が支払い金額と一致しません"
    end
  end

  end_of_this_month = Date.today.end_of_month
  beginning_of_this_month = Date.today.beginning_of_month
  end_of_last_month = Date.today.months_ago(1).end_of_month
  beginning_of_last_month = Date.today.months_ago(1).beginning_of_month
  scope :this_month, -> {where('date >= ? AND date <= ?', beginning_of_this_month, end_of_this_month)}
  scope :last_month, -> {where('date >= ? AND date <= ?', beginning_of_last_month, end_of_last_month)}
  scope :until_last_month, -> {where('date <= ?', end_of_last_month)}
  scope :one_month, -> (begging_of_one_month, end_of_one_month) {where('date >= ? AND date <= ?', begging_of_one_month, end_of_one_month)}
  scope :except_repeat_ones, -> {where.not()}
  scope :category, -> (category_id){unscope(:order).where(category_id: category_id).order(date: :desc, created_at: :desc)}
  scope :both_f, -> {where(both_flg: false)}
  scope :both_t, -> {where(both_flg: true)}
  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_expenses_of_both(user)
    user.expenses.this_month.both_t.newer
  end

  # def self.one_total_expenditures(current_user_expenses, partner_expenses)
  #   current_user_expenses.both_f.sum(:amount) + current_user_expenses.both_t.sum(:mypay) + partner_expenses.sum(:partnerpay)
  # end

  def self.arrange(both_flg)
    expenses = both_flg ? self.both_t : self.both_f
    ids = expenses.where(repeat_expense_id: nil).newer.map{|i| i.id}
    repeat_ones = expenses.where.not(repeat_expense_id: nil).newer.map{|i| i.id}
    unless repeat_ones[0] == nil
      ids += repeat_ones
    end
    order_condition = "CASE id "
    ids.each_with_index do |id, index|
      order_condition << sanitize_sql_array(["WHEN ? THEN ? ", id, index])
    end
    order_condition << sanitize_sql_array(["ELSE ? END", ids.length])
    if ids.empty?
      self.where(id: ids)
    else
      self.where(id: ids).order(order_condition)
    end
  end

  def self.expense_in_both_this_month(current_user, partner)
    current_user.expenses.this_month.both_t.sum(:mypay) + partner.expenses.this_month.both_t.sum(:partnerpay) - current_user.expenses.this_month.both_t.sum(:amount)
  end

  def self.expense_in_both_last_month(current_user, partner)
    current_user.expenses.last_month.both_t.sum(:mypay) + partner.expenses.last_month.both_t.sum(:partnerpay) - current_user.expenses.last_month.both_t.sum(:amount)
  end

  def self.creat_repeat_expenses(s_date, r_date, e_date, repeat_expense, expense_params)
    (s_date..e_date).select{|d| d.day == r_date }.each do |date|
      expense = Expense.new(expense_params)
      expense.date = date
      expense.repeat_expense_id = repeat_expense.id
      expense.save
    end
  end

  def self.update_repeat_expense(old, repeat_expense, expense_params)
    today = Date.today
    old_s_date = old.s_date
    old_e_date = old.e_date
    old_r_date = old.r_date
    s_date = repeat_expense.s_date
    e_date = repeat_expense.e_date
    r_date = repeat_expense.r_date
    if today < s_date
      old_records = user.expenses.where(repeat_expense_id: repeat_expense.id)
      old_records.destroy_all
      creat_repeat_expenses(s_date, r_date, e_date, repeat_expense, expense_params)
    elsif today > e_date
      old_records = user.expenses.where('repeat_expense_id = ? AND date > ?', repeat_expense.id, e_date)
      old_records.destroy_all
    # elsif today > s_date && today < e_date

    end
  end

  def self.destroy_repeat_expenses(user, repeat_expense_id)
    expenses = user.expenses.where('repeat_expense_id = ? AND date >= ?', repeat_expense_id, Date.today.beginning_of_month)
    expenses.destroy_all
  end

end

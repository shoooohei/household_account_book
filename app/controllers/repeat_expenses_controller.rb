class RepeatExpensesController < ApplicationController
  before_action :check_logging_in
  before_action :check_partner
  include CategoriesHelper

  def index
    @current_user_expenses = RepeatExpense.ones_expenses(current_user)
    @current_user_expenses_of_both = RepeatExpense.ones_expenses_of_both(current_user)
    @partner_expenses_of_both = RepeatExpense.ones_expenses_of_both(partner)
  end

  def both
    if params[:back]
      @expense = RepeatExpense.new(repeat_expense_params)
    else
      @expense = RepeatExpense.new
    end
    @common_categories = common_categories
  end

  def new
    if params[:back]
      @expense = RepeatExpense.new(repeat_expense_params)
    else
      @expense = RepeatExpense.new
    end
    @categories = Category.ones_categories(current_user, partner)
  end

  def confirm
    @expense = RepeatExpense.new(repeat_expense_params)
    render :new if @expense.invalid?
  end

  def create
    @repeat_expense = RepeatExpense.new(repeat_expense_params)
    if @repeat_expense.save
      s_date = @repeat_expense.s_date
      e_date = @repeat_expense.e_date
      r_date = @repeat_expense.r_date
      (s_date..e_date).select{|d| d.day == r_date }.each do |date|
        expense = Expense.new(expense_params)
        expense.date = date
        expense.repeat_expense_id = @repeat_expense.id
        expense.save
      end
      redirect_to repeat_expenses_path, notice: "繰り返し出費を保存しました。"
    else
      @categories = Category.ones_categories(current_user, partner)
      render 'index'
    end
  end

  def edit
    @expense = RepeatExpense.find(params[:id])
    if @expense.both_flg == false
      @categories = Category.ones_categories(current_user, partner)
    else
      @common_categories = common_categories
    end
  end

  def update
    @repeat_expense = RepeatExpense.find(params[:id])
    old_s_date = @repeat_expense.s_date
    old_e_date = @repeat_expense.e_date
    old_r_date = @repeat_expense.r_date
    if @repeat_expense.update(repeat_expense_params)
      Expense.update_repeat_expense()
      redirect_to repeat_expenses_path, notice: "繰り返し出費を編集しました。"
    else
      render 'edit'
    end
      (Date.today..@expense.e_date).select{|d| d.day == @expense.r_date }.each do |date|
      end
      # if @expense.s_date < old_s_date
      #   create
      # elsif @expense.s_date > old_s_date
      #   destroy
      # end
      # if @expense.e_date > old_e_date
      #   create
      # elsif @expense.e_date < old_e_date
      #   destroy
      # end


  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "削除しました"
  end

  private
    def mypay_amount
      whole_payment = params[:repeat_expense][:amount].to_i
      case params[:repeat_expense][:percent].to_i
      when 1
        mypay = (whole_payment / 2).round
      when 2
        mypay = (whole_payment / 3).round
      when 3
        mypay = (whole_payment * 2 / 3).round
      when 4
        mypay = 0
      end
      return mypay
    end

    def repeat_expense_params
      if params[:repeat_expense][:both_flg] == "true"
        partnerpay = params[:repeat_expense][:amount].to_i - mypay_amount
        params.require(:repeat_expense).permit(:amount, :s_date, :e_date, :r_date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
      else
        params.require(:repeat_expense).permit(:amount, :s_date, :e_date, :r_date, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
      end
    end

    def expense_params
      if params[:repeat_expense][:both_flg] == "true"
        partnerpay = params[:repeat_expense][:amount].to_i - mypay_amount
        params.require(:repeat_expense).permit(:amount, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id, mypay: mypay_amount, partnerpay: partnerpay )
      else
        params.require(:repeat_expense).permit(:amount, :note, :category_id, :both_flg, :percent).merge(user_id: current_user.id)
      end
    end

    def set_expenses_categories
      @categories = Category.where(user_id: current_user.id).or(Category.where(user_id: partner.id, common: true))
    end
end
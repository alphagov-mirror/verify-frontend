class CleverQuestions::ConfirmingItIsYouController < ApplicationController
  def index
    @form = CleverQuestions::ConfirmingItIsYouForm.new({})
    render 'clever_questions/confirming_it_is_you/confirming_it_is_you'
  end

  def select_answer
    @form = CleverQuestions::ConfirmingItIsYouForm.new(params['confirming_it_is_you_form'] || {})
    current_answers = selected_answer_store.selected_answers['phone'] || {}
    selected_answer_store.store_selected_answers('phone', current_answers.symbolize_keys.merge(@form.selected_answers))
    report_to_analytics('Smart Phone Next')
    redirect_to select_phone_path
  end
end
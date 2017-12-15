require 'rails_helper'
require 'controller_helper'
require 'api_test_helper'
require 'piwik_test_helper'

describe CleverQuestions::OtherIdentityDocumentsController do
  before(:each) do
    set_session_and_cookies_with_loa('LEVEL_2')
    stub_api_idp_list_for_loa
    stub_piwik_request('action_name' => 'Other Documents Next')
  end

  it 'should go to proof of address path and set selected answers when user has other identity documents' do
    post :select_other_documents, params: {
      locale: 'en',
      other_identity_documents_form: { non_uk_id_document: 'true' }
    }

    expect(subject).to redirect_to(select_proof_of_address_path)
    expect(session[:selected_answers]).to eql('other_documents' => { non_uk_id_document: true })
  end

  it 'should not advance if form is invalid' do
    post :select_other_documents, params: {
      locale: 'en',
      other_identity_documents_form: { non_uk_id_document: 'blah' }
    }

    expect(subject).to render_template('index')
  end

  it 'will not replace form values for passport and licence' do
    session[:selected_answers] = { 'documents' => { driving_licence: true, passport: true } }

    post :select_other_documents, params: {
      locale: 'en',
      other_identity_documents_form: { non_uk_id_document: 'true' }
    }

    expect(session[:selected_answers]).to eql('other_documents' => { non_uk_id_document: true }, 'documents' => { passport: true, driving_licence: true })
  end
end
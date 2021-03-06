class MetadataController < ApplicationController
  skip_before_action :validate_session
  skip_before_action :set_piwik_custom_variables
  skip_after_action :store_locale_in_cookie

  rescue_from StandardError do |exception|
    render xml: exception, status: 500
  end

  METADATA_CONTENT_TYPE = "application/samlmetadata+xml".freeze

  def service_providers
    do_not_cache
    render xml: metadata_client.idp_metadata, content_type: METADATA_CONTENT_TYPE
  end

  def identity_providers
    do_not_cache
    render xml: metadata_client.sp_metadata, content_type: METADATA_CONTENT_TYPE
  end

  def service_list
    transactions = transactions_for_service_list
    render json: transactions
  end

private

  def do_not_cache
    response.headers["Cache-Control"] = "no-cache, no-store, no-transform"
  end

  def metadata_client
    METADATA_CLIENT
  end
end

module EidasValidationPartialController
  def ensure_session_eidas_supported
    txn_supports_eidas = session[:transaction_supports_eidas]
    unless txn_supports_eidas
      session_error('Transaction does not support Eidas')
    end
  end
end

# frozen_string_literal: true

require "digest/md5"

module WxCustoms
  # :nodoc:
  module Sign
    SIGN_ALGO_MD5 = "MD5"

    # Generate signature of parameters
    #
    # @see https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=4_5&index=3
    # @raise [ArgumentError] Error raised when `sign_algo` is not supported.
    # @return [String] The sign string.
    # @param params [Hash] Parameters to be signed.
    # @param api_key [String] API key from pay.weixin.qq.com.
    # @param sign_algo [String] Signature algorithm, only support "MD5" now.
    def self.generate(params, api_key, sign_algo = SIGN_ALGO_MD5)
      sorted_params = params.sort.map do |key, val|
        "#{key}=#{val}" unless val.to_s.empty?
      end.compact.join("&")

      string_sign_temp = "#{sorted_params}&key=#{api_key}"

      # Only support MD5 signature algorithm now. Will support SHA1, SHA256, HMAC later.
      # doc: https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=4_1
      case sign_algo
      when SIGN_ALGO_MD5
        Digest::MD5.hexdigest(string_sign_temp).upcase
      else
        raise ArgumentError, "non-supported signature algorithm: #{sign_algo}"
      end
    end
  end
end

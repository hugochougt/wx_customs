# frozen_string_literal: true

require "httparty"

module WxCustoms
  # A Ruby wrapper class for Weixin customs API
  class Client
    include HTTParty

    RETURN_CODE_FAIL = "FAIL"

    base_uri "https://api.mch.weixin.qq.com/cgi-bin/mch"

    format :xml

    attr_accessor :appid, :mch_id, :api_key, :sign_type, :customs, :mch_customs_no

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [WxCustoms::Client]
    def initialize(options = {})
      options.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
      yield(self) if block_given?

      @sign_type ||= WxCustoms::Sign::SIGN_TYPE_MD5
    end

    # Custom declare query API
    #
    # @see https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_1
    # @params params [Hash]
    # @return [HTTParty::Response]
    def custom_declare_order!(params)
      body = merchant_params.merge(params)

      resp = invoke_remote("/customs/customdeclareorder", body)
      raise WxCustoms::Error, resp["xml"]["return_msg"] if resp["xml"]["return_code"] == RETURN_CODE_FAIL

      resp
    end

    # Custom declare order API
    #
    # @see https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_2
    # @params params [Hash]
    # @return [HTTParty::Response]
    def custom_declare_query!(params)
      body = merchant_params.merge(sign_type: sign_type).merge(params)

      resp = invoke_remote("/customs/customdeclarequery", body)
      raise WxCustoms::Error, resp["xml"]["return_msg"] if resp["xml"]["return_code"] == RETURN_CODE_FAIL

      resp
    end

    # Custom declare redeclare API
    #
    # @see https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_4&index=3
    # @params params [Hash]
    # @return [HTTParty::Response]
    def custom_declare_redeclare!(params)
      body = merchant_params.merge(params)

      resp = invoke_remote("/newcustoms/customdeclareredeclare", body)
      raise WxCustoms::Error, resp["xml"]["return_msg"] if resp["xml"]["return_code"] == RETURN_CODE_FAIL

      resp
    end

    private

    def merchant_params
      {
        appid: appid,
        mch_id: mch_id,
        customs: customs,
        mch_customs_no: mch_customs_no
      }
    end

    def invoke_remote(url, body, options = { headers: {} })
      headers = { "Content-Type" => "application/xml" }.merge(options[:headers])

      self.class.post(url, headers: headers, body: xmlify_payload(body))
    end

    def xmlify_payload(body)
      sign = WxCustoms::Sign.generate(body, api_key, sign_type)

      "<xml>#{body.map { |key, val| "<#{key}>#{val}</#{key}>" }.join}<sign>#{sign}</sign></xml>"
    end
  end
end

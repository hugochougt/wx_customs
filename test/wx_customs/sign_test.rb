# frozen_string_literal: true

require "test_helper"

module WxCustoms
  class SignTest < Minitest::Test
    def setup
      @params = {
        appid: "wxd930ea5d5a258f4f",
        mch_id: "10000100",
        device_info: "1000",
        body: "test",
        nonce_str: "ibuaiVcKdpRxkhJA"
      }
      @key = "192006250b4c09247ec02edce69f6a2d"
      @sign = "9A0A8659F005D6984697E2CA0A9CF3B7"
    end

    def test_generate_valid_sign
      assert_equal @sign, WxCustoms::Sign.generate(@params, @key)
    end

    def test_generate_valid_md5_sign
      assert_equal @sign, WxCustoms::Sign.generate(@params, @key, WxCustoms::Sign::SIGN_TYPE_MD5)
    end

    def test_raise_argument_error_when_passing_in_non_supported_sign_type
      assert_raises ArgumentError do
        WxCustoms::Sign.generate(@params, @key, "NON_SUPPORTED")
      end
    end
  end
end

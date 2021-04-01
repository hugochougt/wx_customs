# frozen_string_literal: true

require "test_helper"

module WxCustoms
  class ClientTest < Minitest::Test
    def setup
      @appid = "wxd678efh567hg6787"
      @merchant_id = "1230000109"
      @merchant_api_key = "wx_merchant_api_key"
      @out_trade_no = "20150806125346"
      @transaction_id = "1000320306201511078440737890"
      @customs = "SHANGHAI_ZS"
      @merchant_customs_no = "123456"

      @client = WxCustoms::Client.new do |config|
        config.appid = @appid
        config.mch_id = @merchant_id
        config.api_key = @merchant_api_key
      end
    end

    def test_custom_declare_order_successfully
      success_response = <<~XML
        <xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[成功]]></return_msg>
          <sign_type><![CDATA[MD5]]></sign_type>
          <sign><![CDATA[F2F9933657D30E36D59C80E985AD362F]]></sign>
          <appid><![CDATA[wxd678efh567hg6787]]></appid>
          <mch_id><![CDATA[1230000109]]></mch_id>
          <result_code><![CDATA[SUCCESS]]></result_code>
          <err_code><![CDATA[0]]></err_code>
          <err_code_des><![CDATA[OK]]></err_code_des>
          <state><![CDATA[SUBMITTED]]></state>
          <transaction_id><![CDATA[1000320306201511078440737890]]></transaction_id>
          <out_trade_no><![CDATA[20150806125346]]></out_trade_no>
          <modify_time><![CDATA[20150806125350]]></modify_time>
        </xml>
      XML

      stub_request(:post, /api.mch.weixin.qq.com/i)
        .to_return(body: success_response)

      params = {
        out_trade_no: @out_trade_no,
        transaction_id: @transaction_id,
        customs: @customs,
        mch_customs_no: @merchant_customs_no
      }

      response = @client.custom_declare_order! params

      assert_equal "SUCCESS", response["result_code"]
      assert WxCustoms::Sign.verify?(response, @merchant_api_key)
      assert_equal @appid, response["appid"]
      assert_equal @merchant_id, response["mch_id"]
      assert_equal @out_trade_no, response["out_trade_no"]
      assert_equal "SUBMITTED", response["state"]
    end

    def test_fail_to_custom_declare_order
      fail_response = <<~XML
        <xml>
          <return_code><![CDATA[FAIL]]></return_code>
          <return_msg><![CDATA[转换MchCode失败]]></return_msg>
        </xml>
      XML

      stub_request(:post, /api.mch.weixin.qq.com/i)
        .to_return(body: fail_response)

      params = {
        out_trade_no: @out_trade_no,
        transaction_id: @transaction_id,
        customs: @customs,
        mch_customs_no: @merchant_customs_no
      }

      exception = assert_raises WxCustoms::Error do
        @client.custom_declare_order! params
      end
      assert_equal "转换MchCode失败", exception.message
    end

    def test_custom_declare_query_successfully
      success_response = <<~XML
        <xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[成功]]></return_msg>
          <sign_type><![CDATA[MD5]]></sign_type>
          <sign><![CDATA[F6D86F6A3C51D8E760736AABF913DB87]]></sign>
          <appid><![CDATA[wxd678efh567hg6787]]></appid>
          <mch_id><![CDATA[1230000109]]></mch_id>
          <result_code><![CDATA[SUCCESS]]></result_code>
          <err_code><![CDATA[0]]></err_code>
          <err_code_des><![CDATA[OK]]></err_code_des>
          <transaction_id><![CDATA[1000320306201511078440737890]]></transaction_id>
          <count>1</count>
          <customs_0><![CDATA[SHANGHAI_ZS]]></customs_0>
          <state_0><![CDATA[SUCCESS]]></state_0>
          <modify_time_0><![CDATA[20150806125350]]></modify_time_0>
          <cert_check_result_0><![CDATA[SAME]]></cert_check_result_0>
          <verify_department><![CDATA[UNIONPAY]]></verify_department>
          <verify_department_trade_id><![CDATA[2018112288340107038204310100000]]></verify_department_trade_id>
        </xml>
      XML

      stub_request(:post, /api.mch.weixin.qq.com/i)
        .to_return(body: success_response)

      params = {
        out_trade_no: @out_trade_no,
        customs: @customs,
        mch_customs_no: @merchant_customs_no
      }

      response = @client.custom_declare_query! params

      assert_equal "SUCCESS", response["result_code"]
      assert WxCustoms::Sign.verify?(response, @merchant_api_key)
      assert_equal @appid, response["appid"]
      assert_equal @merchant_id, response["mch_id"]
      response["count"].to_i.times do |n|
        assert_equal "SUCCESS", response["state_#{n}"]
        assert_equal "SAME", response["cert_check_result_#{n}"]
      end
    end

    def test_fail_to_custom_declare_query
      fail_response = <<~XML
        <xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[成功]]></return_msg>
          <sign_type><![CDATA[MD5]]></sign_type>
          <sign><![CDATA[6CA27A3A4DCFB4A72D95553A2E2724B0]]></sign>
          <appid><![CDATA[wxd678efh567hg6787]]></appid>
          <mch_id><![CDATA[1230000109]]></mch_id>
          <result_code><![CDATA[FAIL]]></result_code>
          <err_code><![CDATA[ORDER_NEED_DECLARE]]></err_code>
          <err_code_des><![CDATA[该订单没有申报]]></err_code_des>
        </xml>
      XML

      stub_request(:post, /api.mch.weixin.qq.com/i)
        .to_return(body: fail_response)

      params = {
        out_trade_no: @out_trade_no,
        customs: @customs,
        mch_customs_no: @merchant_customs_no
      }

      exception = assert_raises WxCustoms::Error do
        @client.custom_declare_order! params
      end
      assert_equal "ORDER_NEED_DECLARE: 该订单没有申报", exception.message
    end

    def test_custom_declare_redeclare_successfully
      success_response = <<~XML
        <xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[成功]]></return_msg>
          <sign_type><![CDATA[MD5]]></sign_type>
          <sign><![CDATA[4425DF137D69BF4A762BD01BE33BE1C8]]></sign>
          <appid><![CDATA[wxd678efh567hg6787]]></appid>
          <mch_id><![CDATA[1230000109]]></mch_id>
          <result_code><![CDATA[SUCCESS]]></result_code>
          <err_code><![CDATA[0]]></err_code>
          <err_code_des><![CDATA[OK]]></err_code_des>
          <state><![CDATA[SUCCESS]]></state>
          <transaction_id><![CDATA[1000320306201511078440737890]]></transaction_id>
          <out_trade_no><![CDATA[20150806125346]]></out_trade_no>
          <modify_time><![CDATA[20150806125350]]></modify_time>
        </xml>
      XML

      stub_request(:post, /api.mch.weixin.qq.com/i)
        .to_return(body: success_response)

      params = {
        out_trade_no: @out_trade_no,
        customs: @customs,
        mch_customs_no: @merchant_customs_no
      }

      response = @client.custom_declare_redeclare! params

      assert_equal "SUCCESS", response["result_code"]
      assert WxCustoms::Sign.verify?(response, @merchant_api_key)
      assert_equal @appid, response["appid"]
      assert_equal @merchant_id, response["mch_id"]
      assert_equal @out_trade_no, response["out_trade_no"]
      assert_equal @transaction_id, response["transaction_id"]
    end
  end
end

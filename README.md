# WxCustoms

An unofficial simple Ruby library for the WeChat customs API.

Please read official document first:

- [订单附加信息提交接口 - custom declare order](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_1)
- [订单附加信息查询接口 - custom declare query](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_2)
- [订单附加信息重推接口 - custom declare redeclare](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_4&index=3)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "wx_customs"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wx_customs

## Usage

### Configuration

Create `config/initializers/wx_customs.rb` and pass configuration options as a block to `WxCustoms::Client`.

```ruby
$client = WxCustoms::Client.new do |config|
  config.appid = "YOUR_APPID"
  config.mch_id = "YOUR_MCH_ID"
  config.api_key = "YOUR_API_KEY"
  # If you have multiple `customs` and `mch_customs_no`, you can set them later in API calls
  config.customs = "YOUR_CUSTOMS"
  config.mch_customs_no = "YOUR_MCH_CUSTOMS_NO"
end
```

### Custom Declare Order API

See [订单附加信息提交接口](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_1)

```ruby
params = {
  order_fee: 13110,
  out_trade_no: "15112496832609",
  product_fee: 13110,
  transaction_id: "1006930610201511241751403478",
  transport_fee: 0,
  fee_type: "CNY",
  sub_order_no: "15112496832609001"
}

response = $client.custom_declare_order! params

# You can also config another `customs` and `mch_customs_no` in an API call
$client.custom_declare_order! { customs: "ANOTHER_CUSTOMS", mch_customs_no: "ANOTHER_MCH_CUSTOMS_NO" }.merge(params)
```

### Custom Declare Query API

See [订单附加信息查询接口](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_2)

```ruby
params = {
  transaction_id: "1006930610201511241751403478"
}

response = $client.custom_declare_query! params
```

### Custom Declare Redeclare API

See [订单附加信息重推接口](https://pay.weixin.qq.com/wiki/doc/api/external/declarecustom.php?chapter=18_4&index=3)

```ruby
params = {
  out_trade_no: "15112496832609"
}

response = $client.custom_declare_redeclare! params
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zhaqiang/wx_customs.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

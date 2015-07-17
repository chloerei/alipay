require 'test_helper'

class Alipay::Mobile::SignTest < Minitest::Test
  def test_generate
    assert_equal 'DHEbGJCLa+EzoFTnSDyAerF04sMx/OBO6ObYVISlJqQnCyjGIVxn5JoEoiA82toq1m7VsxfQoTH0IMfN1dZJr0LgwXU3LFr1PvuTy2gyyuOUDTx5Mf5tEH/VfzdMnel8/JFJKffKwRiT+4AwWQ1TaOSIjpFAfI4jts3GVcK4+lE=',
    Alipay::Mobile::Sign.generate({
      service: 'test',
      partner: '123'
    }, {
      sign_type: 'RSA',
      key: TEST_RSA_PRIVATE_KEY
    })
  end
end

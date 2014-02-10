require 'spec_helper'
require File.expand_path('lib/kazkom_epay')

describe KazkomEpay::Signer, '#signed_xml' do
  before(:all) do
    KazkomEpay.configure(
      cert_id: '00C182B189',
      merchant_name: 'Autokupon',
      merchant_id: '92061101',
      private_key_path: KazkomEpay::DEFAULTS[:private_key_path],
      private_key_password: KazkomEpay::DEFAULTS[:private_key_password],
      public_key_path: KazkomEpay::DEFAULTS[:public_key_path]
    )
  end

  subject { kazkom_signer.signed_xml }

  context 'when currency has not been passed to Signer' do
    let(:kazkom_signer) { KazkomEpay::Signer.new(amount: 10, order_id: 242473) }

    it 'should have default (398) currency code' do
      should == '<document><merchant cert_id="00C182B189" name="Autokupon"><order order_id="242473" amount="10" currency="398"><department merchant_id="92061101" amount="10"/></order></merchant><merchant_sign type="RSA">nU+OPJl5cwUaePrLjMt8omv9qJbnZewUarj66DWflDgkUIk+i80evth70eJ/S/td3fxItd/7EKV5tZliAYkvcA==</merchant_sign></document>'
    end
  end

  context 'when currency has been passed to Signer' do
    let(:kazkom_signer) { KazkomEpay::Signer.new(amount: 10, order_id: 242473, currency: 840) }

    it 'should have passed currency code' do
      should == '<document><merchant cert_id="00C182B189" name="Autokupon"><order order_id="242473" amount="10" currency="840"><department merchant_id="92061101" amount="10"/></order></merchant><merchant_sign type="RSA">FqmmUYG/ijHCzCxYvSdomLdpJUkCfMCge/DR8yxwrJEYX8Hy8aG2nZri+XS3/0kqCksmP56S2VRpkvVCOQmEBQ==</merchant_sign></document>'
    end
  end
end

require 'test_helper'

class ValidatorsTest < ActiveSupport::TestCase
  it "is able to validate domain names" do
    %w(google.com sourceafrica.net internal.web1.est.example.com).each do |domain|
      assert DC::Validators::DOMAIN.match(domain), "#{domain} wasn't marked as valid and should be."
    end
    %w(biz$ness.com google.com;drop google.c login).each do |domain|
      refute DC::Validators::DOMAIN.match(domain), "#{domain} was marked as valid and shouldn't be."
    end
  end

  it "validates subdomains" do
    %w(web09 internal staging us-eastern CAPHAPPY).each do |subdomain|
      assert DC::Validators::SUBDOMAIN.match(subdomain), "#{subdomain} wasn't marked as valid and should be."
    end
    %w(dollar$ internal.web bim—bop grünter).each do |subdomain|
      refute DC::Validators::SUBDOMAIN.match(subdomain), "#{subdomain} was marked as valid and shouldn't be."
    end
  end


  it "can validate email addresses" do
    %w(jsmith@example.com david@codeforafrica.org justin+arenstein@gmail.com).each do |email|
      assert DC::Validators::EMAIL.match(email), "#{email} wasn't marked as valid and should be."
    end
    %w(biz[at]docs.com 20#10@gmail.com).each do |email|
      refute DC::Validators::EMAIL.match(email), "#{email} was marked as valid and shouldn't be."
    end
  end
  
  def test_validator_for_external_url_requests
    good_urls = %w[
      http://sourceafrica.net/home
      https://sourceafrica.net/home
    ]
    bad_urls = %w[
      http://127.0.0.1/~ubuntu/.ssh/id_dsa
      http://localhost/~ubuntu/.ssh/id_dsa
      http://2130706433/~ubuntu/.ssh/id_dsa
      http://localhost.fbi.gov/~ubuntu/.ssh/id_dsa
      file:///home/ubuntu/.ssh/id_dsa
      ftp://127.0.0.1/~ubuntu/.ssh/id_dsa
      https://invalid.wtf/lol/?firsthash=#000000&secondhash=#
    ]
    
    good_urls.each{ |url| assert DC::Validators.validate_external_url(url), "#{url} wasn't marked as valid and should be." }
    bad_urls.each{ |url|  refute DC::Validators.validate_external_url(url), "#{url} was marked as valid and shouldn't be." }
  end
end

describe S3Secure::Policy::Document do
  subject { S3Secure::Policy::Document.new("my-bucket", policy_json) }

  describe "already has ForceSSLOnlyAccess" do
    let(:policy_json) {
      <<~JSON
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "ForceSSLOnlyAccess",
                    "Effect": "Deny",
                    "Principal": "*",
                    "Action": "s3:GetObject",
                    "Resource": "arn:aws:s3:::my-bucket/*",
                    "Condition": {
                        "Bool": {
                            "aws:SecureTransport": "false"
                        }
                    }
                }
            ]
        }
      JSON
    }

    it "policy_document" do
      result = subject.policy_document("ForceSSLOnlyAccess")
      expect(result).to include("ForceSSLOnlyAccess")
    end
  end

  describe "doesnt have ForceSSLOnlyAccess" do
    let(:policy_json) {
      <<~JSON
        {
          "Version": "2008-10-17",
          "Id": "PolicyForCloudFrontPrivateContent",
          "Statement": [
            {
              "Sid": "1",
              "Effect": "Allow",
              "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E27G6OAEXAMPLE"
              },
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::test-fake-website/*"
            }
          ]
        }
      JSON
    }

    it "policy_document" do
      result = subject.policy_document("ForceSSLOnlyAccess")
      expect(result).to include("ForceSSLOnlyAccess")
    end
  end

  describe "empty policy" do
    let(:policy_json) { nil }

    it "policy_document" do
      result = subject.policy_document("ForceSSLOnlyAccess")
      expect(result).to include("ForceSSLOnlyAccess")
    end
  end
end

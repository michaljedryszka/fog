require 'fog/collection'
require 'fog/aws/models/ec2/key_pair'

module Fog
  module AWS
    class EC2

      class KeyPairs < Fog::Collection

        attribute :key_name

        model Fog::AWS::EC2::KeyPair

        def initialize(attributes)
          @key_name ||= []
          super
        end

        def all(key_name = @key_name)
          @key_name = key_name
          data = connection.describe_key_pairs(key_name).body
          load(data['keySet'])
        end

        def get(key_name)
          if key_name
            all(key_name).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end

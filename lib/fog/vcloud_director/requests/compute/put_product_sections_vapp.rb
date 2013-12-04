module Fog
  module Compute
    class VcloudDirector
      class Real
        # Puts a list of ProductSection elements from a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        def put_product_sections_vapp(id, body)
          request(
            :expects => 202,
            :method     => 'PUT',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/productSections",
            :body    => body,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.productSections+xml'}
          )
        end
      end
    end
  end
end

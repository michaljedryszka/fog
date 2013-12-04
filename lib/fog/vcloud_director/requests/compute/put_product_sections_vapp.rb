module Fog
  module Compute
    class VcloudDirector
      class Real
        # Puts a list of ProductSection elements from a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        def put_product_sections_vapp(id, prop_list)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
            }
            ProductSectionList(attrs) {
              self[:ovf].ProductSection({"required" => "true"}) {
                self[:ovf].Info "Information about the installed software"
                for item in prop_list
                  ns_attr = {}
                  for key in item.keys
                    ns_attr["ovf:"+key] = item[key]
                  end
                  self[:ovf].Property(ns_attr)
                end
              }
            }
          end.to_xml
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

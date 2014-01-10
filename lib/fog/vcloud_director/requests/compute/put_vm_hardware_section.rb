module Fog
  module Compute
    class VcloudDirector
      class Real
        # Puts virtualHardwareSection document for VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        def put_vm_hardware_section(id, data)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              "xmlns:ovf"=>"http://schemas.dmtf.org/ovf/envelope/1",
              "xmlns:rasd"=>"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData",
              "xmlns:vcloud"=>"http://www.vmware.com/vcloud/v1.5",
              "xmlns:vssd"=>"http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData",
              "vcloud:type"=>"application/vnd.vmware.vcloud.virtualHardwareSection+xml",
              "ovf:transport"=>""
            }
            if data["ovf:transport"]
              attrs["ovf:transport"] = data["ovf:transport"]
            end
            if data["vcloud:href"]
              attrs["vcloud:href"] = data["vcloud:href"]
            end
            self[:ovf].VirtualHardwareSection(attrs) {
              if data["ovf:Info"]
                self[:ovf].Info data["ovf:Info"]
              end
              if data["ovf:System"]
                self[:ovf].System{
                  for key in data["ovf:System"].keys
                    self.send(key, data["ovf:System"][key])
                  end
                }
              end
              if data["ovf:Items"]
                for item in data["ovf:Items"]
                  self[:ovf].Item{
                    for key in item.keys
                      self.send(key, item[key])
                    end
                  }
                end
              end
              if data["vcloud:Links"]
                for item in data["vcloud:Links"]
                  self[:vcloud].Link(item)
                end
              end
            }
          end.to_xml
          Fog::Logger.warning("put_virtual_hardware_section: " + body)
          request(
            :expects => 202,
            :method     => 'PUT',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection",
            :body    => body,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.virtualHardwareSection+xml'}
         )
        end
      end
    end
  end
end

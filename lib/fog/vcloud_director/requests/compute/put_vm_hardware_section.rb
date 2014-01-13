module Fog
  module Compute
    class VcloudDirector
      class Real
        # Puts virtualHardwareSection document for VM.
        #
        # @param [String] id Object identifier of the VM.
        # @param [String] xml document to supply.
        # @return [Excon::Response]
        def put_vm_hardware_section(id, body)

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

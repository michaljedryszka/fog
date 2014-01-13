module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the virtual hardware section of a VM.
        #
        # This operation retrieves the entire VirtualHardwareSection of a VM.
        # You can also retrieve many RASD item elements of a
        # VirtualHardwareSection individually, or as groups of related items.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Nokogiri::XML::SAX::Document] optional parser used for processing response. If nil supplied no parsing will be made
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VirtualHardwareSection.html
        # @since vCloud API version 0.9
        def get_virtual_hardware_section(*args)
          id = args[0]
          parser = nil
          if args.size == 1
            parser = Fog::ToHashDocument.new
          end
          if args.size == 2
            parser = args[1]
          end
          props = {
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :path       => "vApp/#{id}/virtualHardwareSection/"
          }
          if parser
            props[:parser] = parser
          end
          request(props)
        end
      end
    end
  end
end

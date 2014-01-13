#Excon.defaults[:ssl_verify_peer]=false
Shindo.tests('Compute::VcloudDirector | storing product section request', ['vclouddirector']) do
  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Test with invalid data for not existing vapp').raises(Fog::Compute::VcloudDirector::BadRequest) do
    pending if Fog.mocking?
    @service.put_vm_hardware_section('00000000-0000-0000-0000-000000000000', "")
    @service.process_task(task)
  end

  tests('Each vDC') do
    @org[:Link].select do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end.each do |link|
      @vdc = @service.get_vdc(link[:href].split('/').last).body
      tests('Each vApp') do
        @vdc[:ResourceEntities][:ResourceEntity].select do |r|
        r[:type] == 'application/vnd.vmware.vcloud.vApp+xml'
        end.each do |vapp|
          vapp_id = vapp[:href].split('/').last
          vapp = @service.get_vapp(vapp_id).body
          tests('Each VM') do
            vapp[:Children][:Vm].each do |vm|
              vm_id = vm[:href].split('/').last
              tests('Test setting iso transport type')do
                pending if Fog.mocking?
                success = true
                if vm_id
                  r = @service.get_virtual_hardware_section(vm_id, nil)
                  xml_doc  = Nokogiri::XML(r.data()[:body])
                  xml_doc.xpath("//ovf:VirtualHardwareSection").attr("ovf:transport", "iso")
                  Fog::Logger.warning("ISO transport requested")
                  task = @service.put_vm_hardware_section(vm_id, xml_doc.to_s).body
                  @service.process_task(task)
                  r = @service.get_virtual_hardware_section(vm_id, nil)
                  xml_doc  = Nokogiri::XML(r.data()[:body])
                  success = success  && (xml_doc.xpath("//ovf:VirtualHardwareSection").attr("ovf:transport") == "iso")
                end
                success
              end
            end
          end
        end
      end
    end
  end
end
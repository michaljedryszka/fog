#Excon.defaults[:ssl_verify_peer]=false
Shindo.tests('Compute::VcloudDirector | storing product section request', ['vclouddirector']) do
  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Test with sinlge key-value-type entry for not existing vapp').raises(Fog::Compute::VcloudDirector::Forbidden) do
    pending if Fog.mocking?
    data = [{"key"=>"test_key", "value"=>"test_value", "type"=>"string"}]
    @service.put_product_sections_vapp('00000000-0000-0000-0000-000000000000', data)
  end

  tests('Each vDC') do
    @org[:Link].select do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end.each do |link|
      @vdc = @service.get_vdc(link[:href].split('/').last).body
      tests('Each vApp') do
        @vdc[:ResourceEntities][:ResourceEntity].select do |r|
          r[:type] == 'application/vnd.vmware.vcloud.vApp+xml'
        end.each do |v|
          @vapp_id = v[:href].split('/').last
          tests('Test with sinlge key-value-type entry')do
            pending if Fog.mocking?
            data = [{"key"=>"test_key", "value"=>"test_value", "type"=>"string"}]
            task = @service.put_product_sections_vapp(@vapp_id, data).body
            @service.process_task(task)
            response = @service.get_product_sections_vapp(@vapp_id)
            success = true
            if not response.body[:"ovf:ProductSection"]
              success = false
            end
            if not response.body[:"ovf:ProductSection"][:"ovf:Property"]
              success = false
            end
            success
          end
          tests('Test remove entries')do
            pending if Fog.mocking?
            data = []
            task = @service.put_product_sections_vapp(@vapp_id, data).body
            @service.process_task(task)
            response = @service.get_product_sections_vapp(@vapp_id)
            success = true
            if not response.body[:"ovf:ProductSection"]
              success = false
            end
            if response.body[:"ovf:ProductSection"][:"ovf:Property"]
              success = false
            end
            success
          end
        end
      end
    end
  end
end

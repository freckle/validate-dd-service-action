require "dd_validate"

module DDValidate
  describe DDService do
    describe ".load" do
      it "loads a multi-document example" do
        services = DDValidate::DDService.load("examples/multi-invalid-valid.yaml", FetchTestSchema)

        expect(services.length).to eq 4
        expect(services[0].errors).not_to be_empty
        expect(services[1].errors).to be_empty
        expect(services[2].errors).to be_empty
        expect(services[3].errors).to be_empty
      end
    end
  end
end

class FetchTestSchema
  def self.call(version)
    File.read("spec/schema/#{version}.json")
  end
end

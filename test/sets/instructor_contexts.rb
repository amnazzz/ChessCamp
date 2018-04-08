module Contexts
  module InstructorContexts
    def create_instructors
      @mark   = FactoryBot.create(:instructor)
      @alex   = FactoryBot.create(:instructor, first_name: "Alex", bio: nil, phone: "412-268-8211")
      @rachel = FactoryBot.create(:instructor, first_name: "Rachel", bio: nil, active: false)
    end

    def delete_instructors
      @mark.delete
      @alex.delete
      @rachel.delete
    end

    def create_more_instructors
      @mike     = FactoryBot.create(:instructor, first_name: "Mike", last_name: "Ferraco", bio: "A stupendous chess player as you have ever seen.", email: "mike.ferraco@example.com")
      @patrick  = FactoryBot.create(:instructor, first_name: "Patrick", last_name: "Dustmann", bio: "A stupendous chess player as you have ever seen.")
      @austin   = FactoryBot.create(:instructor, first_name: "Austin", last_name: "Bohn", bio: "A stupendous chess player as you have ever seen.")
      @nathan   = FactoryBot.create(:instructor, first_name: "Nathan", last_name: "Hahn", bio: "A stupendous chess player as you have ever seen.", email: "nathan.hahn@example.com")
      @ari      = FactoryBot.create(:instructor, first_name: "Ari", last_name: "Rubinstein", bio: "A stupendous chess player as you have ever seen.")
      @seth     = FactoryBot.create(:instructor, first_name: "Seth", last_name: "Vargo", bio: "A stupendous chess player as you have ever seen.")
      @stafford = FactoryBot.create(:instructor, first_name: "Stafford", last_name: "Brunk", bio: "A stupendous chess player as you have ever seen.")
      @brad     = FactoryBot.create(:instructor, first_name: "Brad", last_name: "Hess", bio: "A stupendous chess player as you have ever seen.")
      @ripta    = FactoryBot.create(:instructor, first_name: "Ripta", last_name: "Pasay", bio: "A stupendous chess player as you have ever seen.")
      @jon      = FactoryBot.create(:instructor, first_name: "Jon", last_name: "Hersh", bio: "A stupendous chess player as you have ever seen.")
      @ashton   = FactoryBot.create(:instructor, first_name: "Ashton", last_name: "Thomas", bio: "A stupendous chess player as you have ever seen.")
      @noah     = FactoryBot.create(:instructor, first_name: "Noah", last_name: "Levin", bio: "A stupendous chess player as you have ever seen.")
    end

    def delete_more_instructors
      @mike.delete
      @patrick.delete
      @austin.delete
      @nathan.delete
      @ari.delete
      @seth.delete
      @stafford.delete
      @brad.delete
      @ripta.delete
      @jon.delete
      @ashton.delete
      @noah.delete
    end
  end
end
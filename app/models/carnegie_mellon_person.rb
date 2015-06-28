class CarnegieMellonPerson < ActiveLdap::Base
  ldap_mapping :dn_attribute => "guid",
               :prefix => "ou=Person",
               :classes => ["cmuPerson"]

  def self.find_by_andrewid( andrewid )
    find("cmuandrewid=#{andrewid}", :attributes => ['cmuAndrewId',
                                                    'cn',
                                                    'mail',
                                                    'sn',
                                                    'givenName',
                                                    'cmuDepartment',
                                                    'cmuStudentClass'
                                                   ])
  end

  def self.autocomplete_results( options={} )
    all( :filter => "(|(cmuandrewid=#{options[:keyword]}*)(cn=#{options[:keyword]}*)(sn=#{options[:keyword]}*))",
         :attributes => ['cmuAndrewId','cn','cmuDepartment'] ).
      map { |x| { primary: [(x.cn)].flatten.first + " (#{x.cmuandrewid})",
                  secondary: x.cmudepartment,
                  data: x.cmuandrewid } }
  end
end

require "bundler/setup"
require "systemu"
require "vagrant-global-status/version"

module Vagrant
  module Global
    module Status
      attr :vms

      def list_vms
        cmd = %q( VBoxManage list vms ) 
        status, stdout, stderr = systemu cmd 
        raise "Problem running command: #{cmd}" unless status.success?
        vms = []
        stdout.each_line do |line|
          m = line.match(/"(.+)" {(.+)}/)
          vms << { :name => m[1], :uuid => m[2] }
        end
        vms
      end

      def vagrantfile_uuid
        vagrantfiles = []
        Dir.glob(File.join(File.expand_path('~/code'), '**/.vagrant/machines')) do |path|
          Dir.glob(File.join(path, '**/virtualbox/id')) do |file|
            vagrantfiles << { :path => file, :uuid => File.new(file).readline }
          end
        end
        vagrantfiles
      end

      def vagrant_status vagrantfile_path
        cmd = %q( vagrant status )
        status, stdout, stderr = systemu cmd, :cwd => vagrantfile_path
        raise "Problem running command: #{cmd}" unless status.success?
        m = stdout.match(/\b\s+(\w+) \(\w+\)/)
        m[1]
      end

      def status
        vms = list_vms
        vagrantfiles = vagrantfile_uuid
        vms.each do |vm|
          puts "VM name: #{vm[:name]}"
          vagrantfile = vagrantfiles.select { |v| v[:uuid] == vm[:uuid] } 
          if vagrantfile.empty?
            vagrantfile = [{:path => "Unknown"}]
          end
          raise "UUIDs should be unique" if vagrantfile.length > 1
          vagrantfile = vagrantfile[0]
          path = vagrantfile[:path].gsub(/\/.vagrant\/machines\/.+\/virtualbox\/id$/, '')
          puts "Vagrantfile path: #{path}"
          if File.directory? path
            status = vagrant_status path
            puts "Vagrant status: #{status}"
          end
          puts
        end
      end
    end
  end
end

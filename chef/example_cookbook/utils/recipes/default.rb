# Example of package installation in one string
package [ "zip", "unzip", "git" ]

# Example of separate package installations 
package "rsync" do
  action :install
end

package "nfs-utils" do
  action :install
end

# Gets the contents of the ssh key files and maps them. In it's own file for potential reusability
locals {
  ssh_files = fileset("${path.module}/.ssh/", "*.pub")
  ssh_keys = { for file in local.ssh_files : file => {
      name       = replace(file, ".pub", "")
      public_key = file("${path.module}/.ssh/${file}")
    }
  }
}
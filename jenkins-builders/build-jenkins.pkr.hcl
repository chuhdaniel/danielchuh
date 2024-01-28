# build-jenkins.pkr.hcl

build {
  sources = [
    "source.amazon-ebs.jenkins-ami"
  ]

  provisioner "shell" {
    inline = [
      "echo Updating Packages",
      "sudo yum update --security -y"
    ]
  }

  post-processor "manifest" {
    output = "jenkins-manifest.json"
  }
}
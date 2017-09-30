resource "null_resource" "local-exec" {

    provisioner "local-exec" {
        command = "sleep 1200"
      }
}


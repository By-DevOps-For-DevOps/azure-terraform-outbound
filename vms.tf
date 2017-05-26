resource "azurerm_virtual_machine" "proxy_machine" {
  count = "${var.proxy_vm_count}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-proxy-machine${count.index}-${var.suffix}"
  location = "${var.location}"
  availability_set_id = "${azurerm_availability_set.proxy.id}"
  vm_size = "Standard_DS1"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  network_interface_ids = [
    "${element(azurerm_network_interface.proxy_network_interface.*.id, count.index)}"
  ]

  primary_network_interface_id = "${element(azurerm_network_interface.proxy_network_interface.*.id, count.index)}"

  storage_image_reference {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.3"
    version = "latest"
  }

  storage_os_disk {
    name = "${var.prefix}-proxy-disk${count.index}-${var.suffix}"
    vhd_uri = "${element(azurerm_storage_account.proxy_storage_account.*.primary_blob_endpoint, count.index)}${element(azurerm_storage_container.proxy_storage_container.*.name, count.index)}/proxydisk.vhd"
    caching = "ReadWrite"
    create_option = "FromImage"
    os_type = "linux"
  }

  os_profile {
    computer_name = "${var.vm_hostname}"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
    connection {
      host = "${element(azurerm_public_ip.proxy_public_ip.*.ip_address, count.index)}"
      private_key = "${file(var.vm_admin_private_key)}"
      user = "${var.vm_admin_username}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
      "rm -f /tmp/script.sh",
    ]
    connection {
      host = "${element(azurerm_public_ip.proxy_public_ip.*.ip_address, count.index)}"
      private_key = "${file(var.vm_admin_private_key)}"
      user = "${var.vm_admin_username}"
    }
  }

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

resource "azurerm_virtual_machine" "test_machine" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-test-machine-${var.suffix}"
  location = "${var.location}"
  vm_size = "Standard_DS1"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  network_interface_ids = [
    "${azurerm_network_interface.test_network_interface.id}"
  ]

  primary_network_interface_id = "${azurerm_network_interface.test_network_interface.id}"

  storage_image_reference {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.3"
    version = "latest"
  }

  storage_os_disk {
    name = "${var.prefix}-test-disk-${var.suffix}"
    vhd_uri = "${azurerm_storage_account.test_storage_account.primary_blob_endpoint}${azurerm_storage_container.test_storage_container.name}/testdisk.vhd"
    caching = "ReadWrite"
    create_option = "FromImage"
    os_type = "linux"
  }

  os_profile {
    computer_name = "${var.vm_hostname}"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = "${var.vm_admin_public_key}"
    }
  }

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

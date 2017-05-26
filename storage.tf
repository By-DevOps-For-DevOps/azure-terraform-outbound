//------------------- Proxy --------------------------------------
resource "azurerm_storage_account" "proxy_storage_account" {
  count = "${var.proxy_vm_count}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}proxysa${count.index}${var.suffix}"
  location = "${var.location}"
  account_type = "Premium_LRS"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

resource "azurerm_storage_container" "proxy_storage_container" {
  count = "${var.proxy_vm_count}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-proxy-storage-container${count.index}-${var.suffix}"
  storage_account_name = "${element(azurerm_storage_account.proxy_storage_account.*.name, count.index)}"
  container_access_type = "private"
}

//------------------- Test --------------------------------------
resource "azurerm_storage_account" "test_storage_account" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}testsa${var.suffix}"
  location = "${var.location}"
  account_type = "Premium_LRS"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

resource "azurerm_storage_container" "test_storage_container" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  name = "${var.prefix}-test-storage-container-${var.suffix}"
  storage_account_name = "${azurerm_storage_account.test_storage_account.name}"
  container_access_type = "private"
}

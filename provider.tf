terraform {
  required_version = ">= 0.9, < 1.0"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "resource_group" {
  name = "${var.prefix}-resource-group-${var.suffix}"
  location = "${var.location}"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

resource "azurerm_availability_set" "proxy" {
  name = "${var.prefix}-proxy-availability-set-${var.suffix}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  platform_fault_domain_count = 1
  platform_update_domain_count = 1

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}
resource "azurerm_network_security_group" "proxy_nsg" {
  name = "${var.prefix}-proxy-nsg-${var.suffix}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  security_rule {
    name = "virtual-network"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  // TODO: remove after testing
  security_rule {
    name = "allow-rdp"
    priority = 200
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = 22
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "http"
    priority = 300
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = 80
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "https"
    priority = 400
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = 443
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }

}

resource "azurerm_network_security_group" "test_nsg" {
  name = "${var.prefix}-test-nsg-${var.suffix}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  security_rule {
    name = "internal-anything"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

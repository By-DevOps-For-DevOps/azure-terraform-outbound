resource "azurerm_virtual_network" "virtual_network" {
  name = "${var.prefix}-network-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  address_space = [
    "${var.virtual_network_address_space}"
  ]
  location = "${var.location}"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

//------------------- Proxy subnet --------------------------------------
resource "azurerm_network_interface" "proxy_network_interface" {
  count = "${var.proxy_vm_count}"
  name = "${var.prefix}-proxy-network-interface${count.index}-${var.suffix}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  enable_ip_forwarding = true

  network_security_group_id = "${azurerm_network_security_group.proxy_nsg.id}"

  ip_configuration {
    name = "${var.prefix}-ip-configuration${count.index}-${var.suffix}"
    subnet_id = "${azurerm_subnet.proxy_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${element(azurerm_public_ip.proxy_public_ip.*.id, count.index)}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }
}

resource "azurerm_subnet" "proxy_subnet" {
  name = "${var.prefix}-proxy-subnet-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  address_prefix = "${var.proxy_subnet_address_prefix}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
}

resource "azurerm_public_ip" "proxy_public_ip" {
  count = "${var.proxy_vm_count}"
  name = "${var.prefix}-proxy-public-ip${count.index}-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location = "${var.location}"

  public_ip_address_allocation = "static"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

//------------------- Test (Diego app) subnet ----------------------------
resource "azurerm_network_interface" "test_network_interface" {
  name = "${var.prefix}-test-network-interface-${var.suffix}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  network_security_group_id = "${azurerm_network_security_group.test_nsg.id}"

  ip_configuration {
    name = "${var.prefix}-ip-configuration-${var.suffix}"
    subnet_id = "${azurerm_subnet.test_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.test_public_ip.id}"
  }
}

resource "azurerm_subnet" "test_subnet" {
  name = "${var.prefix}-test-subnet-${var.suffix}"
  address_prefix = "${var.test_subnet_address_prefix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  route_table_id = "${azurerm_route_table.test_route_table.id}"
}

//------------------- Test Router ----------------------------------------
resource "azurerm_route_table" "test_route_table" {
  name = "${var.prefix}-test-route-table-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location = "${var.location}"

  tags {
    Name = "${var.prefix}-${var.suffix}"
  }
}

resource "azurerm_route" "test_route" {
  name = "${var.prefix}-test-route-${var.suffix}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  route_table_name = "${azurerm_route_table.test_route_table.name}"
  address_prefix = "0.0.0.0/0"
  next_hop_type = "VirtualAppliance"
  next_hop_in_ip_address = "${var.proxy_lp_ip}"
}

locals { ### local variable = key1 = value1, value2, value3 , key2 = value1,value2, vle
  vm_inputs = {
    "vm-app1" = {
      vm_name  = "vm-linux-01"
      size     = "Standard_D2s_v3"
      username = "vmadmin"
      password = "Welcome@12345"
    },
    "vm-app2" = {
      vm_name  = "vm-linux-02"
      size     = "Standard_B1ms"
      username = "linuxuser"
      password = "Password@12345"
    },
    "vm-app3" = {
      vm_name  = "vm-linux-03"
      size     = "Standard_B1ms"
      username = "linuxuser"
      password = "Password@12345"
    }
  }
}
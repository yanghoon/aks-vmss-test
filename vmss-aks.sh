# References
#   https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-availability-zones#availability-considerations
# 
# Placement Group (per Each Zone)
# Zone Type
#   R : Regional
#   S : Single Availability Zone
#   M : Multi Availability Zone
# Spread Type
#   M : Max Spreading on All Fault Domains
#   F : Static 5 Fault Domains
# Acronym
#   RF: Regional    + Static 5 FD  (+ Single Placement Group)
#   SM: Single Zone + Max FD       (+ Multi Placement Group)
#   MM: Multi Zone  + Max FD       (+ Multi Placement Group)



## Create AKS Node Pool (vmss)
RG=cloudzcp-pog-ssang276
KUBE=aks-vmss-koc
# az aks nodepool list -g $RG --cluster-name $KUBE -o table
# az aks nodepool add -g $RG --cluster-name $KUBE -n vmssrf -s Standard_B2s -c 6
KUBE=aks-vmss-jpe
# az aks nodepool list -g $RG --cluster-name $KUBE -o table
# az aks nodepool add -g $RG --cluster-name $KUBE -n vmssrf -s Standard_B2s -c 6
# az aks nodepool add -g $RG --cluster-name $KUBE -n vmsssm -s Standard_B2s -c 6 -z 1
# az aks nodepool add -g $RG --cluster-name $KUBE -n vmssmm -s Standard_B2s -c 6 -z 1 2 3



## Test - Single Zone
RG=MC_cloudzcp-pog-ssang276_aks-vmss-koc_koreacentral
# az vmss list -g $RG -o table --query '[*].{name:name, location:location, zones:to_string(zones), capacity:sku.capacity, platformFaultDomainCount:to_string(platformFaultDomainCount), singlePlacementGroup:singlePlacementGroup}'
Name                         Location      Zones    Capacity    PlatformFaultDomainCount    SinglePlacementGroup
---------------------------  ------------  -------  ----------  --------------------------  ----------------------
aks-agentpool-39611801-vmss  koreacentral  null     6           null                        True
aks-vmssrf-39611801-vmss     koreacentral  null     6           null                        True

# az vmss get-instance-view -g $RG -n $VMSS --instance-id '*' -o table --query '[*].{computerName:computerName, platformFaultDomain:to_string(platformFaultDomain), platformUpdateDomain:to_string(platformUpdateDomain), placementGroupId:placementGroupId}'
# VMSS=aks-agentpool-39611801-vmss
ComputerName                       PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------------------------  ---------------------  ----------------------  ------------------------------------
aks-agentpool-39611801-vmss000000  0                      0                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44
aks-agentpool-39611801-vmss000001  1                      1                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44
aks-agentpool-39611801-vmss000002  2                      2                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44
aks-agentpool-39611801-vmss000003  3                      3                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44
aks-agentpool-39611801-vmss000004  4                      4                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44
aks-agentpool-39611801-vmss000005  0                      1                       a750605e-cb73-4f8b-bcd5-ea5bfcd2cc44

# VMSS=aks-vmssrf-39611801-vmss
ComputerName                    PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
------------------------------  ---------------------  ----------------------  ------------------------------------
aks-vmssrf-39611801-vmss000000  0                      0                       5bf3f380-4fc6-4de6-89a2-7f91d5282719
aks-vmssrf-39611801-vmss000001  1                      1                       5bf3f380-4fc6-4de6-89a2-7f91d5282719
aks-vmssrf-39611801-vmss000002  2                      2                       5bf3f380-4fc6-4de6-89a2-7f91d5282719
aks-vmssrf-39611801-vmss000003  3                      3                       5bf3f380-4fc6-4de6-89a2-7f91d5282719
aks-vmssrf-39611801-vmss000004  4                      4                       5bf3f380-4fc6-4de6-89a2-7f91d5282719
aks-vmssrf-39611801-vmss000005  0                      1                       5bf3f380-4fc6-4de6-89a2-7f91d5282719



## Test - Multi AZ
RG=MC_cloudzcp-pog-ssang276_aks-vmss-jpe_japaneast
# az vmss list -g $RG -o table --query '[*].{name:name, location:location, zones:to_string(zones), capacity:sku.capacity, platformFaultDomainCount:to_string(platformFaultDomainCount), singlePlacementGroup:singlePlacementGroup}'
Name                         Location    Zones          Capacity    PlatformFaultDomainCount    SinglePlacementGroup
---------------------------  ----------  -------------  ----------  --------------------------  ----------------------
aks-agentpool-39011005-vmss  japaneast   null           6           null                        True
aks-vmssmm-39011005-vmss     japaneast   ["1","2","3"]  6           5                           True
aks-vmssrf-39011005-vmss     japaneast   null           6           null                        True
aks-vmsssm-39011005-vmss     japaneast   ["1"]          6           5                           True

# az vmss get-instance-view -g $RG -n $VMSS --instance-id '*' -o table --query '[*].{computerName:computerName, platformFaultDomain:to_string(platformFaultDomain), platformUpdateDomain:to_string(platformUpdateDomain), placementGroupId:placementGroupId}'
# VMSS=aks-agentpool-39011005-vmss
ComputerName                       PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------------------------  ---------------------  ----------------------  ------------------------------------
aks-agentpool-39011005-vmss000000  0                      0                       cc93ef60-cc75-44ef-98df-d21cace558a1
aks-agentpool-39011005-vmss000001  1                      1                       cc93ef60-cc75-44ef-98df-d21cace558a1
aks-agentpool-39011005-vmss000002  2                      2                       cc93ef60-cc75-44ef-98df-d21cace558a1
aks-agentpool-39011005-vmss000003  3                      3                       cc93ef60-cc75-44ef-98df-d21cace558a1
aks-agentpool-39011005-vmss000004  4                      4                       cc93ef60-cc75-44ef-98df-d21cace558a1
aks-agentpool-39011005-vmss000005  0                      1                       cc93ef60-cc75-44ef-98df-d21cace558a1

# VMSS=aks-vmssmm-39011005-vmss
ComputerName                    PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
------------------------------  ---------------------  ----------------------  ------------------------------------
aks-vmssmm-39011005-vmss000000  0                      null                    14e609a0-8d62-4c34-9464-115f75068974
aks-vmssmm-39011005-vmss000001  0                      null                    d04d6c49-79af-4090-ae05-6b09c4aa416d
aks-vmssmm-39011005-vmss000002  0                      null                    6fc0345c-dacb-4b14-aaf6-c5a4202717cd
aks-vmssmm-39011005-vmss000003  1                      null                    14e609a0-8d62-4c34-9464-115f75068974
aks-vmssmm-39011005-vmss000004  1                      null                    d04d6c49-79af-4090-ae05-6b09c4aa416d
aks-vmssmm-39011005-vmss000005  1                      null                    6fc0345c-dacb-4b14-aaf6-c5a4202717cd

# VMSS=aks-vmssrf-39011005-vmss
ComputerName                    PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
------------------------------  ---------------------  ----------------------  ------------------------------------
aks-vmssrf-39011005-vmss000000  0                      0                       60fba093-c7fc-4be8-8a51-99ad6b478130
aks-vmssrf-39011005-vmss000001  1                      1                       60fba093-c7fc-4be8-8a51-99ad6b478130
aks-vmssrf-39011005-vmss000002  2                      2                       60fba093-c7fc-4be8-8a51-99ad6b478130
aks-vmssrf-39011005-vmss000003  3                      3                       60fba093-c7fc-4be8-8a51-99ad6b478130
aks-vmssrf-39011005-vmss000004  4                      4                       60fba093-c7fc-4be8-8a51-99ad6b478130
aks-vmssrf-39011005-vmss000005  0                      1                       60fba093-c7fc-4be8-8a51-99ad6b478130

# VMSS=aks-vmsssm-39011005-vmss
ComputerName                    PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
------------------------------  ---------------------  ----------------------  ------------------------------------
aks-vmsssm-39011005-vmss000000  0                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb
aks-vmsssm-39011005-vmss000001  1                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb
aks-vmsssm-39011005-vmss000002  2                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb
aks-vmsssm-39011005-vmss000003  3                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb
aks-vmsssm-39011005-vmss000004  4                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb
aks-vmsssm-39011005-vmss000005  0                      null                    1b0fe1f1-df90-4598-ace5-008540dbb4eb

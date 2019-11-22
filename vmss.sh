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

RG=cloudzcp-pog-ssang276
# az vmss list -g $RG -o table
# az vmss list -g $RG -o table --query '[*].{name:name, location:location, zones:to_string(zones), capacity:sku.capacity, platformFaultDomainCount:platformFaultDomainCount, singlePlacementGroup:singlePlacementGroup}'
Name          Location      Zones          Capacity    PlatformFaultDomainCount    SinglePlacementGroup
------------  ------------  -------------  ----------  --------------------------  ----------------------
vmssMM000jpe  japaneast     ["1","2","3"]  6           1                           False
vmssRF000jpe  japaneast     null           6           5                           True
vmssSM000jpe  japaneast     ["1"]          6           1                           False
vmssRF000koc  koreacentral  null           6           5                           True


# az vmss get-instance-view -g $RG -n $VMSS --instance-id '*' -o table
# az vmss get-instance-view -g $RG -n $VMSS --instance-id '*' -o table --query '[*].{computerName:computerName, platformFaultDomain:to_string(platformFaultDomain), platformUpdateDomain:to_string(platformUpdateDomain), placementGroupId:placementGroupId}'

# VMSS=vmssRF000koc
ComputerName     PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------  ---------------------  ----------------------  ------------------------------------
vmssrf000000002  2                      2                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00
vmssrf000000003  3                      3                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00
vmssrf000000004  4                      4                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00
vmssrf000000005  0                      1                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00
vmssrf000000006  1                      2                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00
vmssrf000000007  2                      3                       1cfb452a-a77c-4dae-ac34-12bc1d8fcd00

# VMSS=vmssRF000jpe
ComputerName     PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------  ---------------------  ----------------------  ------------------------------------
vmssrf000000002  2                      2                       c5de8107-cb9b-4fd2-be04-26818c91f2d5
vmssrf000000003  3                      3                       c5de8107-cb9b-4fd2-be04-26818c91f2d5
vmssrf000000004  4                      4                       c5de8107-cb9b-4fd2-be04-26818c91f2d5
vmssrf000000005  0                      1                       c5de8107-cb9b-4fd2-be04-26818c91f2d5
vmssrf000000006  1                      2                       c5de8107-cb9b-4fd2-be04-26818c91f2d5
vmssrf000000007  2                      3                       c5de8107-cb9b-4fd2-be04-26818c91f2d5

# VMSS=vmssSM000jpe
ComputerName     PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------  ---------------------  ----------------------  ------------------------------------
vmsssm000000001  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa
vmsssm000000002  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa
vmsssm000000003  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa
vmsssm000000004  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa
vmsssm000000005  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa
vmsssm000000006  0                      null                    3e513a9e-b910-4a2f-aa9a-e384473251aa

# VMSS=vmssMM000jpe
ComputerName     PlatformFaultDomain    PlatformUpdateDomain    PlacementGroupId
---------------  ---------------------  ----------------------  ------------------------------------
vmssmm000000000  0                      null                    91774ac4-866e-40dd-9b33-b14ad12e2661
vmssmm000000001  0                      null                    ae5a893b-b7fd-4cfc-9404-20247f931b6c
vmssmm000000002  0                      null                    87f40060-4ebb-4649-b50a-0c6c9c0a9543
vmssmm000000003  0                      null                    91774ac4-866e-40dd-9b33-b14ad12e2661
vmssmm000000004  0                      null                    ae5a893b-b7fd-4cfc-9404-20247f931b6c
vmssmm000000005  0                      null                    87f40060-4ebb-4649-b50a-0c6c9c0a9543
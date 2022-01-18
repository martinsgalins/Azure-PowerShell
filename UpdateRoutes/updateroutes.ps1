Connect-AzAccount
$rt = Get-AzRouteTable -Name RT01
$rc = Get-AzRouteConfig -RouteTable $rt
foreach ($route in $rc)
{
    Set-AzRouteConfig -RouteTable $rt -Name $route.Name -AddressPrefix $route.AddressPrefix -NextHopType $route.NextHopType -NextHopIpAddress 1.1.1.1
}

Set-AzRouteTable -RouteTable $rt
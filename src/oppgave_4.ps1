# BLACKJACK 

# input params
param (
    [Parameter()]
    [Uri]
    $UrlKortstokk
)

# GET request params ---- TODO: check out that '@' syntax ^^
$httpParams = @{
    Uri         = $UrlKortstokk
    Method      = 'GET'
    ContentType = 'application/json'
}

$Response = Invoke-RestMethod @httpParams


# prints all the cards
foreach ($card in $Response)
{
  Write-Host "Kortstokk: $($card.suit.Substring(0, 1))$($card.value)"
}
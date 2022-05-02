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

$Response = Invoke-RestMethod @HttpParams

$DeckAsString = "Kortstokk: "

# Hash Table for deck suits
$CardSuits = @{C = '♣️'; D = '♦️'; H = '♥️'; S = '♠️';}

### add all the cards to one string
foreach ($Card in $Response)
{
  if ($Card -eq $Response[-1]){
    #$DeckAsString += "$($Card.suit.Substring(0, 1))$($Card.value)"

    # with emoji
    $DeckAsString += "$($Card.value)$($CardSuits[$Card.suit.Substring(0, 1)])"
  } else{
    #$DeckAsString += "$($Card.suit.Substring(0, 1))$($Card.value),"

    # with emoji
    $DeckAsString += "$($Card.value)$($CardSuits[$Card.suit.Substring(0, 1)]),"
  }
}

Write-Host $DeckAsString
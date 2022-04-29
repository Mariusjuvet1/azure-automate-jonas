# BLACKJACK 

# GET request params ---- TODO: check out that '@' syntax ^^
$httpParams = @{
    Uri         = 'http://nav-deckofcards.herokuapp.com/shuffle'
    Method      = 'GET'
    ContentType = 'application/json'
}

$Response = Invoke-RestMethod @httpParams


# prints all the cards
foreach ($card in $Response)
{
  Write-Host "$($card.suit.Substring(0, 1))$($card.value)"
}
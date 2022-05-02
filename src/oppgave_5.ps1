# BLACKJACK 
# input params
param (
    [Parameter()]
    [Uri]
    $UrlKortstokk
)

# init an empty array
$DeckOfCards = @()

# GET request params ---- TODO: check out that '@' syntax ^^
$HttpParams = @{
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

# takes in an array/list of card values aka. card.value
function GetCardScore {
    param (
        $CardDeck
    )
    $FaceCards = @{A = 11; K = 10; Q = 10; J = 10;}
    $SumOfCards = 0

    foreach ($Card in $CardDeck){
        if ($Facecards.ContainsKey($Card.value)) {
            $SumOfCards += $($FaceCards[$Card.value])
        } else {
            $SumOfCards += $Card.value -as [int]
        }
    }

    Write-Host "Score: $SumOfCards"
}

GetCardScore -CardDeck $Response
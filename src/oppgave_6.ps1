# BLACKJACK 
function GetDeckOfCards{

    param (
        [Parameter()]
        [Uri]
        $UrlKortstokk
    )

    # GET request params ---- TODO: check out that '@' syntax ^^
    $HttpParams = @{
        Uri         = $UrlKortstokk
        Method      = 'GET'
        ContentType = 'application/json'
    }

    return Invoke-RestMethod @HttpParams
}

### takes inn deck in JSON and return it as a comma-seperated string.
function DeckToString{
    param (
        $CardDeck
    )

    # Hash Table for deck suits
    $CardSuits = @{C = '♣️'; D = '♦️'; H = '♥️'; S = '♠️';}

    $DeckAsString = ""

    foreach ($Card in $CardDeck){
        if ($Card -eq $CardDeck[-1]){
            #$DeckAsString += "$($Card.suit.Substring(0, 1))$($Card.value)"

            # with emoji
            $DeckAsString += "$($Card.value)$($CardSuits[$Card.suit.Substring(0, 1)])"
        } else{
            #$DeckAsString += "$($Card.suit.Substring(0, 1))$($Card.value),"

            # with emoji
            $DeckAsString += "$($Card.value)$($CardSuits[$Card.suit.Substring(0, 1)]),"
        }
    }
    return $DeckAsString
}

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

    return $SumOfCards
}

function DealCards{
    param (
        $CardDeck
    )

    $MyHand = DeckToString -CardDeck $CardDeck[0..1]
    $MagnusHand = DeckToString -CardDeck $CardDeck[2..3]
    $CardDeck = DeckToString -CardDeck $CardDeck[4..$CardDeck.Count]

    Write-Host "meg: $MyHand "
    Write-Host "Magnus: $MagnusHand "
    Write-Host "KortStokk: $CardDeck "

}

$DeckOfCards = GetDeckOfCards -UrlKortstokk 'http://nav-deckofcards.herokuapp.com/shuffle'
$DeckAsString = DeckToString -CardDeck $DeckOfCards
$Score = GetCardScore -CardDeck $DeckOfCards

DealCards -CardDeck $DeckOfCards
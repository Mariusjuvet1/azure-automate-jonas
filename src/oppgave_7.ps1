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

    # my hand
    $MyHand = DeckToString -CardDeck $CardDeck[0..1]
    $MyHandScore = GetCardScore -CardDeck $CardDeck[0..1]

    # magnus's hand
    $MagnusHand = DeckToString -CardDeck $CardDeck[2..3]
    $MagnusHandScore = GetCardScore -CardDeck $CardDeck[2..3]

    # remove the cards dealt
    $CardDeck = DeckToString -CardDeck $CardDeck[4..$CardDeck.Count]

    return @{
        player1 = @{ name = 'meg'; cards = $MyHand; score = $MyHandScore; };
        player2 = @{ name = 'Magnus'; cards = $MagnusHand; score = $MagnusHandScore; };
        deck = $CardDeck[4..$CardDeck.Count];
    }
}

function PlayBlackJack{
    $DeckOfCards = GetDeckOfCards -UrlKortstokk 'http://nav-deckofcards.herokuapp.com/shuffle'
    $CurrentGame = DealCards -CardDeck $DeckOfCards

    if ($CurrentGame.player1.score -eq $CurrentGame.player2.score) {
        Write-Host "Vinner: Draw"
    } else {
        Write-Host "Vinner: $(($CurrentGame.player1.score -gt $CurrentGame.player2.score) ? $CurrentGame.player1.name : $CurrentGame.player2.name)"
    }

    Write-Host "$($CurrentGame.player1.name) | $($CurrentGame.player1.score) | $($CurrentGame.player1.cards)"
    Write-Host "$($CurrentGame.player2.name) | $($CurrentGame.player2.score) | $($CurrentGame.player2.cards)"

}

PlayBlackJack

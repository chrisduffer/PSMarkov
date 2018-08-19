function New-MarkovChain {
    #[CmdletBinding()]
    param (
        # Input array
        [Parameter(Mandatory)]
        [string[]]
        $InputArray
    )
    
    Write-Debug "Input  $InputArray"

    $chain = @{}

    # work through input array to build upmthe hash or add to the value array
    for ($i = 0; $i -lt ($InputArray.Count -1); $i++) {
        $node = $InputArray[$i]
        $next = $InputArray[$i+1]

        $chain[$node] += @($next)
    }
    $chain
}


function New-MarkovSimulation {
    [CmdletBinding()]
    param (
        # Input markov chain as a hash
        [Parameter(Mandatory)]
        [hashtable]
        $InputChain,

        # Maximum simulations
        [int]
        $MaxSimulations = 10,

        # Starting state
        [string]
        $StartingState,

        # If get to this state, stop
        [string]
        $EndState
    )

    if ($StartingState) {
        if ($StartingState -notin $InputChain.Keys) {
            throw "$StartingState is not a valid starting state for the supplied chain"
        }
    }
    else {
        $StartingState = ($InputChain.Keys | Get-Random)
    }

    $outputStates = @($StartingState)

    Write-Debug "Starting state: $StartingState"
    $currentState = $StartingState
    for ($i = 0; $i -lt $MaxSimulations; $i++) {
        # if we hit the end state, stop
        if ($EndState -and ($currentState -eq $EndState)) {
            continue
        }
        $nextState = ($InputChain[$currentState] | Get-Random)
        Write-Debug "$i  Current: $currentState Next: $nextState"
        $outputStates += $nextState
        $currentState = $nextState
    }
    
    $outputStates
}
#####################################################################
#INDIVIDUAL TASK 2a. Explain, critique, comment, and debug code (MLO2)
#####################################################################

import random

'''Dice-based cricket match simulation Owzthat for one player
   One dice (called the “batting” dice) is labelled 1, 2, 3, 4, “owzthat” and 6. 
   A second dice (called the “umpire” dice) is labelled “bowled”, “stumped”,
   “caught”, “not out”, “no ball” and “lbw”. Before starting the match, the
   number of balls to be bowled and the number of wickets available are set
   (so balls and wickets are the resources to be used up over the simulated
    cricket match). Each time a ball is bowled, the player rolls the batting
   dice. If the batting dice lands on 1, 2, 3, 4 or 6, that number of runs is
   added to the total runs scored. However, if the batting dice lands on
   “owzthat” then the player rolls the umpire dice to determine the outcome
   of the appeal. If the umpire dice lands on “bowled”, “stumped”, “caught”
   or “lbw” then the batter is out (the player loses one wicket) and no runs
   are scored. If the umpire dice lands on “not out” then no wickets are lost
   and no runs are scored. If the umpire dice lands on “no ball” then the
   player adds one run to the total runs scored and the ball must be bowled
   again. The match finishes when either all the balls have been bowled or
   all the wickets have been lost (whichever comes first). The aim is to
   maximize the total number of runs scored'''

print('Dice-based cricket match simulation Owzthat for one player.\n')

batting_options = ['1','2','3','4','6','owzthat']
umpire_options = ['bowled','stumped','caught','lbw','no ball','not out']

def cricket(ball, wickets):
    print('Number of balls and wickets set for the match are', ball, 'and', wickets, 'respectively.\n')

    print('Note:')
    print("1. The batting dice contains the following values: ['1','2','3','4','6','owzthat']. and is rolled first for each ball until the predetermined number of balls (or) wickets is reached.")
    print("2. The Umpire dice has ['bowled','stumped','caught','lbw','no ball','not out'] and is rolled when the batting dice reveals 'owzthat'.\n")
    for j in range(0,2):
        score, wicket, num_no_ball, runs_no_ball, not_out_decisions = 0, 0, 0, 0, 0
        if j == 0:
            print('\nORIGINAL OWZTHAT GAME')
        else:
            print('\nVARIANT GAME')
        print('\nScore is set to (Runs/Wickets): ( 0 / 0 )\n')
        for i in range (1,ball + 1):
            if wicket == wickets:
                overs_played = [(i-1) // 6, (i-1) % 6]
                break
            else:
                score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions = batting(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions)
                print('Score : (', score, '/', wicket, ')')
                print('Number of balls bowled:',i)
                overs_played = [ball // 6, ball % 6]
        print('\nTotal score:', score, '/', wicket)
        print('Total no-balls bowled:', num_no_ball)
        print('Total runs scored in no-balls:', runs_no_ball)
        print('Total overs played:', overs_played[0], '.', overs_played[1], 'overs')
        print("Total number of 'not out' decisions made by umpire dice:", not_out_decisions)

def batting(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions):
    run = random.choice(batting_options)
    print("\nNow rolling the batting dice.")
    if run == '1' or run == '2' or run == '3' or run == '4' or run == '6':
        score += int(run)
        print('Runs scored :', int(run))
    elif run == 'owzthat':
        print('Chance of a wicket as we got an appeal "owzthat" from the batting dice.')
        decision = random.choice(umpire_options)
        print("Umpire Dice will be rolled now.")
        if decision == 'bowled' or decision == 'stumped' or decision =='caught' or decision == 'lbw':
            wicket += 1
            print("And it's a wicket. Incredibly", decision, ".")
        elif decision == 'no ball':
            if j == 0:
                num_no_ball += 1
                score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions = no_ball(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions)
            elif  j == 1:
                score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions = real_no_ball(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions)
        elif decision == 'not out':
            print('Umpire dice says "Not Out".')
            not_out_decisions += 1
    return score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions

def no_ball(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions):
    print("Seems like a 'No Ball' here. An additional ball will be bowled and 1 run is added to the score.")
    score += 1
    score1 = score
    print('Score : (', score, '/', wicket, ')')
    score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions = batting(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions)
    runs_no_ball = score - score1 + 1
    return score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions

def real_no_ball(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions):
    num_no_ball += 1
    runs_no_ball += 1
    print("Seems like a 'No Ball' here. An additional ball will be bowled and 1 run is added to the score.")
    print("And it's a 'Free Hit'.")
    score += 1
    print('Score : (', score, '/', wicket, ')')
    real_umpire_options = ['no ball','not out','run out']
    run = random.choice(batting_options)
    print("Now rolling the batting dice.")
    if run == '1' or run == '2' or run == '3' or run == '4' or run == '6':
        score += int(run)
        runs_no_ball += int(run)
        print("Runs scored in 'Free Hit' :", int(run))
    elif run == 'owzthat':
        print('Chance of a wicket as we got an appeal "owzthat" from the batting dice.')
        real_decision = random.choice(real_umpire_options)
        print("Umpire Dice will be rolled now, which is specialized for additional ball.")
        if real_decision == 'run out':
            wicket += 1
            print("And it's a wicket. Incredibly", real_decision, ".")
        elif real_decision == 'no ball':
            run = 'owzthat'
            while run == 'owzthat':
                run = random.choice(batting_options)
            score += int(run)
            runs_no_ball += int(run)
            print('Runs scored in the additional ball :', int(run))
            score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions = real_no_ball(score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions)
        elif real_decision == 'not out':
            print('Umpire dice says "Not Out".')
            not_out_decisions += 1
            run = 'owzthat'
            while run == 'owzthat':
                run = random.choice(batting_options)
            score += int(run)
            runs_no_ball += int(run)
            print("Runs scored in 'Free Hit' :", int(run))
    return score, wicket, j, num_no_ball, runs_no_ball, not_out_decisions

cricket(10, 2)
    
            



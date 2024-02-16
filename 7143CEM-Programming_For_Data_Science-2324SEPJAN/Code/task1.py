#####################################################################
#INDIVIDUAL TASK 1b. Explain, critique, comment, and debug code (MLO2)
#####################################################################

def whatdoido(L):
    '''Arrange values in Descending order for index 1 to len(L)-2'''
    s = True                                # s is a flag.
    print('A flag is used to stop the "while" loop that is used to sort the whole sequence and it is set to', s, 'to initiate the while loop.')
    comp = 0
    swap = 0
    print('There are 2 counters to count no. of comparisons and swaps that happened in the code.')
    while (s):                              # while loop runs till the end of sort.
        s = False
        print('Flag is set to',s,'after entering "while" loop.')
        for i in range(1,len(L)-3):         # sort the sequence range from 1 to len(L)-3.
            comp = comp + 1
            print('comparison Count =',comp)
            print('Elements in comparison are',L[i],'and',L[i+1],'.')
            if (L[i] < L[i+1]):
                # now swap values L[i] and L[i+1]
                print('As',L[i],'is less than',L[i+1],', we are swapping them.')
                L[i], L[i+1] = L[i+1], L[i]
                swap = swap + 1
                print('Swap count =',swap)
                s = True
                print('Flag is set to',s,'after swap.')

        for i in range(len(L)-3,1,-1):      # sort the sequence range from len(L)-3 to 1.
            comp = comp + 1
            print('comparison Count =',comp)
            print('Elements in comparison are',L[i],'and',L[i+1],'.')
            if (L[i] < L[i+1]):
                # now swap values L[i] and L[i+1]
                print('As',L[i],'is less than',L[i+1],', we are swapping them.')
                L[i], L[i+1] = L[i+1], L[i]
                swap = swap + 1
                print('Swap count =',swap)
                s = True
                print('Flag is set to',s,'after swap.')
        print('Sequence at the end of a "while" loop iteration is',L,'.')
    return(L)                               # returns the sorted sequence.


L = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]#[10,9,1,7,6,5,4,9,6,0] #['g','f','a','d','c','b','a'] 

print('To Arrange values in Descending order for index 1 to len(L)-2 in the given sequence.')
print('The sequence that was sent to sort is', L,'.')

print('After sorting, the sequence is', whatdoido(L),'.')

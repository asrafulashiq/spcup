## get last index of every grid
ind = np.zeros(8)
current = 0
for i in xrange(1,8):
    while True:
        if target[current][0]>i:
            ind[i-1] = current - 1
            break
        current += 1            
    
ind[7] = len(target)-1
ind = [int(i) for i in ind]
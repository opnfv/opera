
a={'a':'1.2','b':'1.1','c':'1.0'}
b=sorted(a.items(),key=lambda i:i[1])
c=[i[0] for i in b]
#sorted(b, cmp=lambda x,y: cmp(a[x],a[y]))
print c

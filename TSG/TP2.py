from pylab import *
import scipy
from scipy.signal import lfilter
def dirac(n):
    d=zeros(n)
    d[0]=1
    return d
a1=-1.76
a2=0.8
N=100
x=dirac(N)
y=lfilter([1,1/2],[1, a1 , a2],x)
stem(y)

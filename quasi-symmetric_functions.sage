try:
    load('algebra_class.sage')
except IOError:
    load('../algebra_class/algebra_class.sage')

from types import MethodType
 
def QuasiSymmetricFunctions(base=QQ):
    """
    Returns the ring of quasi-symmetric functions over base
    """
    name = "The ring of quasi-symmetric functions over "+str(base)
    unit = ()
    def mul(s,t):
        if s == ():
            return {t:base(1)}
        if t == ():
            return {s:base(1)}
        D1,D2,D3 = mul(s[1:],t),mul(s,t[1:]),mul(s[1:],t[1:])
        DD1 = defaultdict(lambda:0,{(s[0],)+x:D1[x] for x in D1})
        DD2 = defaultdict(lambda:0,{(t[0],)+x:D2[x] for x in D2})
        DD3 = defaultdict(lambda:0,{(s[0]+t[0],)+x:D3[x] for x in D3})
        for D in [DD1,DD2]:
            for x in D:
                DD1[xx] += D[x]
                if x in DD1:
                    DD1[x] += D[x]
                else:
                    DD1[x] = D[x]
        return D
    order = lambda s:(sum(s),)+s
    def rep(s,brace=False):
        if s == unit:
            return ""
        elif len(s) == 1:
            return "M_{%i}"%s[0] if brace else "M_%i"%s[0]
        else:
            return "M_{%s}"%print_tuple(s)[1:-1]
    tex = lambda s:rep(s,brace=True)
    init = lambda s:defaultdict(lambda:0,{s:base(1)})
    is_inv = lambda D:all(D[s]==0 or s==unit for s in D) and base(D[unit]).is_unit()
    inv = lambda D:defaultdict(lambda:0,{unit:base(D[unit])^(-1)})
    R = Algebra(name=name,base=base,unit=unit,mul=mul,order=order,rep=rep,tex=tex,init=init,\
               is_inv=is_inv,inv=inv)
    return R
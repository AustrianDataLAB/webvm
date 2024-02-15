#!/bin/bash
# RSA reference in bash
# do not use this for anything execept educational use.
# this is not a license thing. it's rather a good advice.

p=$1    # prime
q=$2    # prime
msg=$3  # the message
max=$((p * q)) # calc max for flattening
phi=$(((p-1)*(q-1)))

# set of some primes. primitve RNG ;) 
pubprimes=( 1901 1907 1913 1931 1933 1949 1951 1973 1979 \
  7841 7853 7867 7873 7877 7879 7883 7901 7907 7919 \
  127  131  137  139  149  151  157  163  167  173 \
  6311 6317 6323 6329 6337 6343 6353 6359 6361 6367 \
  2221 2237 2239 2243 2251 2267 2269 2273 2281 2287 )

# choose one of those primes for starting
e=${pubprimes[$RANDOM % ${#pubprimes[@]}]}

# extended euclid algorithm. borrowed and simplified from
# https://sites.google.com/site/algorithms2013/home/number-theory/extended-gcd-bash
function ext_euclid_algo() {
    agcd=$1
    b=$2
    x=0
    lastx=1
    y=1
    lasty=0
    while [ $b != 0 ]; do
        tempb=$b
        tempx=$x
        tempy=$y

        quotient=$(($agcd / $b))
        b=$(($agcd - $(($b * $(($agcd / $b))))))
        x=$(($lastx-$(($quotient*$x))))
        y=$(($lasty-$(($quotient*$y))))

        agcd=$tempb
        lastx=$tempx
        lasty=$tempy
    done

    echo $((lastx+$2))
}

# calculate matching private key (d) to choosen pubkey
d=$(ext_euclid_algo $e $phi)

# print generated key environment
echo "pub: $e"
echo "priv: $d"
echo "phi: $phi"

# show original message
echo "orig msg: $msg"

# encrypt message
i=$msg
for x in $(seq 2 $e); do
    msg=$((msg*i))      # multiply
    msg=$((msg%max))    # flatten
done
echo "encr msg: $msg"

# decrypt message
i=$msg
for x in $(seq 2 $d); do
    msg=$((msg*i))      # multiply
    msg=$((msg%max))    # flatten
done
echo "decr msg: $msg"
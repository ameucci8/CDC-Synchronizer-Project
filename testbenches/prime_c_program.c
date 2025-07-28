void listPrimes(int N, int primes[]) {
    int mem_index = 0;
    int N_plus_one = N+1;
    for (int i = 2; i != N_plus_one; i++) {
        if (isPrime(i)) {
            primes[mem_index] = i;
            mem_index++;
        }
    }
}

bool isPrime(int num) {
    bool res = true;
    int remainder = 1;
    for (int D = 2; D < num; D++) {
        remainder = num;
        while(remainder > 0){
            remainder = remainder - D;
        }
        if(remainder == 0) {
            break;
        }
    }
    if(remainder == 0) {
        res = false;
    }
    return res;
}
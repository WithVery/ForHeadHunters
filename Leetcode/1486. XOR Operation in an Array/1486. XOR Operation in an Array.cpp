class Solution {
public:
    int xorOperation(int n, int start) {
/*        
        // "generic" solution
        int result = start;
        for(int i = 1; i < n; i++) {
            result = result ^ (start + 2 * i);
        }
        return result;
*/

        // "fast" solution
        #define CACHE_SIZE (7)
        int cycleCache[CACHE_SIZE] = { -1,-1,-1,-1,-1,-1,-1 };

        int result = start;
        int nCacheIdx = 0;
        bool bJumped = false;
        for (int i = 1; i < n; i++) {
            result = result ^ (start + 2 * i);
            // search o populate cycleCache
            if (!bJumped) {
                bool bDupFound = false;
                for (int j = 0; j < nCacheIdx; j++) {
                    if (cycleCache[j] == result) {
                        bDupFound = true;
                        break;
                    }
                }
                if (bDupFound) {
                    // jump to the end part of array if we have sections to jump
                    if (4 < n - i) {
                        int nSections = (n - i) / 4;
                        i = i + 4 * nSections;
    					if (n == i) i -= 4; // margin condition
                        bJumped = true;
                    }
                }
                else {
                    if (nCacheIdx < CACHE_SIZE) {
                        cycleCache[nCacheIdx++] = result;
                    }
                }
            }
        }
        return result;
    }
};
class Solution {
public:
    int countVowelSubstrings(string word) {
	unordered_map<char, char> vowels;
	vowels.insert({ 'a', 0b00001 });
	vowels.insert({ 'e', 0b00010 });
	vowels.insert({ 'i', 0b00100 });
	vowels.insert({ 'o', 0b01000 });
	vowels.insert({ 'u', 0b10000 });

	char FullStringMarker = 0b00001 | 0b00010 | 0b00100 | 0b01000 | 0b10000;

	int count = 0;

	for (int i = 0; i < word.length(); i++) {
		int is = 0;
		int ie = 0;
		if (vowels.find(word[i]) != vowels.end()) { // first vowel found
			is = i;
			bool bConFound = false;
			for (int j = i + 1; j < word.length(); j++) {
				if (vowels.find(word[j]) == vowels.end()) { // first consonnant found
					bConFound = true;
					ie = j - 1;
					break;
				}
			}
			if (!bConFound) {
				ie = word.length() - 1;
			}
			i = ie + 1;

			// found!
			if (is <= ie) { // process substring
				while (is <= ie - 4) { // we need 5 symbols at least;
					char nMarker = 0;
					for (int k = 0; k <= ie - is; k++) {
						nMarker |= vowels.at(word[is + k]);
						if ((nMarker & FullStringMarker) == FullStringMarker) { // full house!
							count += ie - is - k + 1;
							break;
						}
					}
					is++;
				}
			}
		}
	}
	return count;
    }
};
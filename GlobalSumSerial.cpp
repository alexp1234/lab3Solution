/*
 * GlobalSum.cpp
 *
 *  Created on: Oct 11, 2020
 *      Author: ITCS 3145
 */

#include <iostream>

using namespace std;

class Sum{
public:
	int globalSum(int first, int end);
};

int Sum::globalSum(int first, int last){
	int sum = 0;
	for (int i = first; i <= last; i++)
		sum += i;

	return sum;
}

int main(int argc, char *argv[]){
	// Preparation
	int first = (int) strtol(argv[1], NULL, 10);
	int last = (int) strtol(argv[2], NULL, 10);

	Sum sum;
	cout << "Sum in serial from " << first << " to " << last
			<< " is equal to " << sum.globalSum(first, last) << endl;

	return 0;
}

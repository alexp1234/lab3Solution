/*
 * GlobalSum.cpp
 *
 *  Created on: Oct 11, 2020
 *      Author: ITCS 3145
 */

#include <iostream>
#include <mpi.h>
#include <time.h>
using namespace std;

class Sum{
public:
	long globalSum(long first, long end);
	long globalSumMPILinear(long first, long end); // Incomplete

private:
	long calculateLocalSum(long first, long last, int rank, int process_num); // Incomplete
};

long Sum::globalSum(long first, long last){
	long sum = 0;
	for (long i = first; i <= last; i++)
		sum += i;

	return sum;
}

long Sum::calculateLocalSum(long first, long last, int rank, int process_num){
	long local_sum = 0;
	long my_first = first;
	long my_last = last;

	// TODO Fill a statement to calculate chunk_size
	// need to split the chunk into process_number - 1 groups

	int chunk_size = (last - first + process_num) / (process_num);
	// TODO Fill a statement to calculate my_first
	my_first = first + chunk_size * rank;
	
	// TODO Fill a statement to calculate my_last
	my_last = my_first + chunk_size - 1 > last ? last : my_first + chunk_size - 1;
	
	for (long i = my_first; i <= my_last; i++)
		local_sum += i;

	return local_sum;
}

long Sum::globalSumMPILinear(long first, long last){
	long global_sum = 0;

	int rank, process_num;
	// TODO Fill a statement to retrieve the process rank and save it to the 
	// variable, rank
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	// TODO Fill a statement to retrieve the total number of processes 
	// save it to the variable, process_num
	// this line below appears to be not working

	MPI_Comm_size(MPI_COMM_WORLD, &process_num);
	long start=clock();

	// Calculate the partial sum for each process 
	// by calling the function calculateLocalSum
	long local_sum = calculateLocalSum(first, last, rank, process_num);
    // TODO Fill statements to let non-rank zero process send local_sum to the master process (rank=0)
	// and let the rank-zero process aggregate the received local_sum into the global_sum (any receiving order is fine)

	if (rank == 0) {
		for(int i = 1; i < process_num; i++){
					MPI_Recv(&local_sum, 1, MPI_LONG, i, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
					global_sum = global_sum + local_sum;
		}
		long end=clock();
		    cout << "Number of processes: " << process_num
		    		<< " Global Sum takes " << (end - start) << " clicks ("
		    		<< ((end-start)*1000 / (CLOCKS_PER_SEC + 0.0)) << " milliseconds)\n";

		cout << "Sum from " << first << " to " << last
				<< " is equal to " << global_sum << endl;
	}
	else{
		MPI_Send(&local_sum, 1, MPI_LONG, 0, 1, MPI_COMM_WORLD);
	}
	return global_sum;
}

int main(int argc, char *argv[]){
	// Preparation
	long first = (long) strtol(argv[1], NULL, 10);
	long last = (long) strtol(argv[2], NULL, 10);

	Sum sum;
	//cout << "Sum in serial from " << first << " to " << last
	//		<< " is equal to " << sum.globalSum(first, last) << endl;

	MPI_Init(&argc, &argv);
	sum.globalSumMPILinear(first, last);
	MPI_Finalize();

	return 0;
}

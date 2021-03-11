PRJ_NAME=GlobalSum
GCC=mpic++

OUTPUT=${PRJ_NAME}
SOURCES=${PRJ_NAME}.cpp
HFILES=
CCFLAGS=-std=c++11 -g3 -O1 -lm

all: ${OUTPUT}
${OUTPUT}:
	${GCC} -o ${OUTPUT} ${CCFLAGS} ${HFILES} ${SOURCES}
    
clean:
	rm -f ${OUTPUT}
   


objs/glm.o: source/glm.cc
	mkdir -p objs
	$(CPP) -o objs/glm.o -c source/glm.cc -I$(GLM_INCLUDE) -O3

all: objs/glm.o

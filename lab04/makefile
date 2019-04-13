CXX = g++
CXXFLAGS = -g -Wall -pedantic

p_wykonywalny = program

main = main
lib01 = Swarm
lib02 = Czastka
lib03 = V2d
lib04 = Area

$(p_wykonywalny): $(main).o $(lib01).o $(lib02).o $(lib03).o $(lib04).o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(main).o: $(main).cpp $(lib01).hpp $(lib02).hpp $(lib03).hpp $(lib04).hpp

$(lib01).o: $(lib01).cpp $(lib01).hpp 

$(lib02).o: $(lib02).cpp $(lib02).hpp 

$(lib03).o: $(lib03).cpp $(lib03).hpp 

$(lib04).o: $(lib04).cpp $(lib04).hpp

.PHONY: run clean

run:
	./$(p_wykonywalny)

clean:
	rm -rf *.o $(p_wykonywalny)

crun:
	rm -rf *.o
	./$(p_wykonywalny)
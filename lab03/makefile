CXX = g++
CXXFLAGS = -g -Wall -pedantic

p_wykonywalny = program

main = genetic_alg
lib01 = funkcje

$(p_wykonywalny): $(main).o $(lib01).o
	$(CXX) $(CXXFLAGS) $^ -o $@

$(main).o: $(main).cpp $(lib01).h

$(lib01).o: $(lib01).cpp $(lib01).h

.PHONY: clean run

clean:
	rm -rf *.o $(p_wykonywalny)

run:
	./$(p_wykonywalny)

type messagefile; 
type countfile; 

app (countfile t) countwords (messagefile f) {   
     sleep 1 stdout=@filename(t);
}

string inputNames = "scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh";

messagefile inputfiles[] <fixed_array_mapper;files=inputNames>;

foreach f,i in inputfiles {
  countfile c <single_file_mapper; file=@strcat(i, ".result")>;
//  countfile c;
  c = countwords(f);
}

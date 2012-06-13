type messagefile; 
type countfile; 

app (countfile t) countwords (int s) {   
     sleep s stdout=@filename(t);
}

int sleepTime = @toint(@arg("sleeptime","1"));

string inputNames = "scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh scott3a.sh";

messagefile inputfiles[] <fixed_array_mapper;files=inputNames>;

foreach f,i in inputfiles {
  countfile c <single_file_mapper; file=@strcat(i, ".result")>;
  c = countwords(sleepTime);
}

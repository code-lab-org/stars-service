#include <unistd.h>
#include <fstream>

int main(int argc, char** argv) {
  std::string workspace = argv[1];
  std::ofstream log;
  log.open(workspace + "/log.txt");
  for (unsigned int i = 1; i < 61; i++) {
    log << i/60.0*100.0 << "%" << std::endl;
    sleep(1);
  }
  log.close();
  std::ofstream data;
  data.open(workspace + "/data.nc4");
  data << "data\n";
  data.close();
  return 0;
}

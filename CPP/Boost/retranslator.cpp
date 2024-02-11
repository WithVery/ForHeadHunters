#include <boost/lockfree/spsc_queue.hpp>
#include <boost/process.hpp>

#include <iostream>
#include <unistd.h>
#include <chrono>
#include <thread>

#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#include <fcntl.h>
#include <fstream>
#include <string.h>

// network stuff
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <memory.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <errno.h>
#include <stdlib.h>

#include <vector>
#include <algorithm>
#include <iterator>
#include <sstream>
#include <iomanip>
#include <stdarg.h>
extern "C" {
#include <pci/pci.h>
}

namespace bp = boost::process; //we will assume this for all further examples

using namespace std;

#define PIPE_READ 0
#define PIPE_WRITE 1

#define START_FRAME_MARKER (0x47)

const static char log_file[] = "log.txt";

// #define _DEBUG_
//#define _DEBUG_OUTPUT_

#define INPUT_BUF_SIZE (65535)

typedef struct {
  int size;
  char content[INPUT_BUF_SIZE];
} input_buf_element;


#define BUF_SIZE (1316)
//char buf[BUF_SIZE];

int aStdoutPipe[2];
pid_t cid;
boost::lockfree::spsc_queue<input_buf_element> input_queue{1000};
int sum = 0;

void log_error(const std::string &asErrorMessage) {
  std::ofstream errlog(log_file, std::ios::app);
  auto t = std::time(nullptr);
  auto tm = *std::localtime(&t);
  errlog << "[" << std::put_time(&tm, "%x %X") <<"]: " << asErrorMessage << std::endl;
}

void __attribute__((noreturn)) die(char *msg, ...) {
    va_list args;
    va_start(args, msg);
    fprintf(stderr, "pcisdn: ");
    
    //vfprintf(stderr, msg, args);
    //std::string message = "pcisdn: " + line;
    //fputc('\n', stderr);

    char *line;
    vsprintf(line, msg, args);

    log_error("pcisdn: " + std::string(line));

    exit(1);
}

bool  do_something_secret(uint32_t alw, uint32_t ahw) {
  return false;
}

bool canIRunIt() {
  struct pci_access *pacc;
  struct pci_dev *dev;  
  struct pci_filter filter;
  struct pci_cap *pdsn;  

  pacc = pci_alloc();     /* Get the pci_access structure */
  pacc->error = die;

  uint32_t lw = 0;
  uint32_t hw = 0;

  pci_scan_bus(pacc);     // We want to get the list of devices /
  for (dev=pacc->devices; dev; dev=dev->next) { // Iterate over all devices /
    if(pci_filter_match(&filter, dev)) { // Select only our slot 
      pdsn = pci_find_cap(dev, PCI_EXT_CAP_ID_DSN, PCI_CAP_EXTENDED);
      if(pdsn) {
        lw = pci_read_long(dev, pdsn->addr + 4);
        hw = pci_read_long(dev, pdsn->addr + 8);
        //printf("%8.8lx%8.8lx\n", hw, lw);
      }
    }
  }
  pci_cleanup(pacc);      // Close everything

  return do_something_secret(lw, hw);
}

#ifndef _DEBUG
int resolvehelper(const string& hostname, int family, const string& service, sockaddr_storage* pAddr) {  
  addrinfo* result_list = NULL;
  addrinfo hints = {};
  hints.ai_family = family;
  hints.ai_socktype = SOCK_DGRAM; // UDP only
  int result = getaddrinfo(hostname.c_str(), service.c_str(), &hints, &result_list);
  if (result == 0) {
    memcpy(pAddr, result_list->ai_addr, result_list->ai_addrlen);
    freeaddrinfo(result_list);
  }
  return result;
}
#endif

// get data from FFMPEG output and queue the data
void FFMPEGOutputProcessor() { 
  while(true) {

    ifstream cmddata("./cmdline.txt");
    string cmdline = "";
    if(!getline(cmddata, cmdline) || cmdline.empty()) { 
      std::ofstream errlog(log_file, std::ios::app);
      auto t = std::time(nullptr);
      auto tm = *std::localtime(&t);
      errlog << "[" << std::put_time(&tm, "%x %X") <<"]: " << "command line file is empty or invalid" << std::endl;
      std::this_thread::sleep_for(std::chrono::milliseconds(5000));
      break;
    }

    bp::ipstream errstr; //error pipe-stream
    bp::ipstream istr; //reading pipe-stream

    //bp::child c("/usr/bin/ffmpeg -loglevel error -re -i testsrc.mpg -c:v libx264 -b:v 3000k -c:a aac -f mpegts -", bp::std_out > istr);
    bp::child c(cmdline, bp::std_out > istr);    
    std::string renicer = "renice -n 20 -p " + std::to_string(c.id()); 
    bp::child renice_it(renicer);
    int bytesread;
    char content[INPUT_BUF_SIZE];
    //std::array<char, INPUT_BUF_SIZE> buf;
    int totalbytes = 0;

    while (c.running() ) {

      //istr.read(buf.data(), buf.size());
      istr.read(content, INPUT_BUF_SIZE);
      int bytesread = istr.gcount();
      if(0 < bytesread) {
        input_buf_element ibe;
        memcpy(ibe.content, content, bytesread);
        ibe.size = bytesread;

        input_queue.push(ibe);

      }

    std::ofstream errlog("log.txt", std::ios::app);
    std::string line;

    while (std::getline(errstr, line) && !line.empty()) {
      std::ofstream errlog(log_file, std::ios::app);
      auto t = std::time(nullptr);
      auto tm = *std::localtime(&t);
      errlog << "[" << std::put_time(&tm, "%x %X") <<"]: " << line << std::endl;
    }


      //std::cout << bytesread << std::endl;
      //totalbytes += bytesread;
    }
    c.wait(); //wait for the process to exit   

    // std::cout << "Total: " << totalbytes << std::endl;

    int result = c.exit_code();  
    // std::cout << "Child exited with " << result << std::endl;
    // std::this_thread::sleep_for(std::chrono::milliseconds(5000));
  }
}


//void queueConsumer(string asIP, string asPort) {
void queueConsumer() {

  string destIP = "127.0.0.1";
  string destPort = "1234";

  {
    ifstream targetdata("./target.txt");
    string addrline = "";
    if(!getline(targetdata, addrline) || addrline.empty()) { 
      std::ofstream errlog(log_file, std::ios::app);
      auto t = std::time(nullptr);
      auto tm = *std::localtime(&t);
      errlog << "[" << std::put_time(&tm, "%x %X") <<"]: " << "address  file is empty or invalid" << std::endl;
      std::this_thread::sleep_for(std::chrono::milliseconds(5000));
      return;
    }
    else {
      int pos = addrline.find(":");
      if(0 < pos) {
        destIP = addrline.substr(0, pos);
        destPort = addrline.substr(pos + 1);
      }
    }
  }

  // UDP socket setup section
  int result = 0;
  int sock = socket(AF_INET, SOCK_DGRAM, 0);

  sockaddr_storage addrDest = {};
  result = resolvehelper(destIP, AF_INET, destPort, &addrDest);
  if (result != 0) {
    int lasterror = errno;
    std::cout << "error: " << lasterror;
    exit(1);
  }


#ifdef _DEBUG_OUTPUT_
  ofstream outfile;
  outfile.open("debug.4", std::ios_base::app); 
#endif

  int totalbytes = 0;

  char buf[BUF_SIZE];
  int bidx = 0;

  int delays_count = 0;
  // int count = 0;

  while(true) {
    input_buf_element ibe;
    if(input_queue.pop(ibe)) { // do we have anything ready to process?
#ifdef _DEBUG_OUTPUT_
      // outfile.write(ibe.content, ibe.size);
#endif      
      // totalbytes += ibe.size;
      int nbytes = ibe.size;
      if (nbytes) {
        int bytesleft = nbytes;
        int readstart = 0;
        while (bidx + bytesleft >= BUF_SIZE) {
          int chunk = BUF_SIZE - bidx;
          memcpy((void*)(buf + bidx), &ibe.content[readstart], chunk);
          bidx = 0;
          readstart += chunk;
#ifdef _DEBUG_OUTPUT_
          outfile.write(buf, BUF_SIZE);
          cout << BUF_SIZE << endl;
#endif          
          totalbytes += chunk;
          // UDP socket section
          result = sendto(sock, buf, BUF_SIZE, 0, (sockaddr*)&addrDest, sizeof(addrDest));
          // cout << totalbytes << endl;
          bytesleft -= chunk;
        }
        if(bytesleft > 0) {
          memcpy((void*)(buf + bidx), &ibe.content[readstart], bytesleft);
          bidx += bytesleft;
          totalbytes += bytesleft;
        }
      }
      delays_count = 0;
    }
    else {
      // std::this_thread::sleep_for(std::chrono::milliseconds(1000));
      // continue;
      if(delays_count > 20) {
        break;
      }
      else {
#ifdef _DEBUG_
      cout << "timeout: " << delays_count << endl;
#endif
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        delays_count++;
      }
    }
  }
  if(bidx > 0) {
#ifdef _DEBUG_
    outfile.write(buf, bidx);
    totalbytes += bidx;
    cout << bidx << endl;
#else
    result = sendto(sock, buf, bidx, 0, (sockaddr*)&addrDest, sizeof(addrDest));
#endif              
  }

#ifdef _DEBUG_
  cout << totalbytes << " bytes transferred\n";
#endif
}

int main() {
    //thread queueConsumerThread(queueConsumer, "127.0.0.1", "1234");
    //thread queueConsumerThread(queueConsumer, "192.168.1.74", "1234");
    thread queueConsumerThread(queueConsumer);
    thread ffmpegProcessorThread(FFMPEGOutputProcessor);

    // sched_param sch_params;
    // sch_params.sched_priority = 2;
    // if(pthread_setschedparam(queueConsumerThread.native_handle(), SCHED_RR, &sch_params)) {
    //   auto t = std::time(nullptr);
    //   auto tm = *std::localtime(&t);
    //   std::ofstream errlog("log.txt", std::ios::app);
    //   errlog << "[" << std::put_time(&tm, "%x %X") <<"]: " << "Failed to set thread scheduling : " << std::strerror(errno) << std::endl;
    // }
    
    if(queueConsumerThread.joinable()) {
      queueConsumerThread.join();
      // queueConsumerThread.detach();
    }

    if(ffmpegProcessorThread.joinable()) {
      ffmpegProcessorThread.join();
      // ffmpegProcessorThread.detach();
    }

}
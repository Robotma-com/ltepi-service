# -*- coding: utf-8 -*-

import sys
import threading
import time
import subprocess

# sys.argv[0] ... The network interface name to be monitored

class Monitor(threading.Thread):
  def __init__(self, nic):
    super(Monitor, self).__init__()
    self.nic = nic
  
  def run(self):
    while True:
      err = subprocess.call("ip route | grep %s" % self.nic, shell=True)
      if err != 0:
        print("LTEPi modem is terminated. Shutting down.")
        break
      err = subprocess.call("ip route | grep default | grep -v %s" % self.nic, shell=True)
      if err == 0:
        ls_nic_cmd = "ip route  | grep default | grep -v %s | tr -s ' ' | cut -d ' ' -f 5" % self.nic
        ls_nic = subprocess.Popen(ls_nic_cmd, shell=True, stdout=subprocess.PIPE).stdout.read()
        for nic in ls_nic.split("\n"):
          if nic:
            ip_cmd = "ip route | grep %s | awk '/default/ { print $3 }" % nic
            ip = subprocess.Popen(ip_cmd, shell=True, stdout=subprocess.PIPE).stdout.read()
            subprocess.call("ip route del default via %s" % ip, shell=True)
      time.sleep(5)
  
def main(nic):
  monitor = Monitor(nic)
  monitor.start()
  monitor.join()

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print("USB Ethernet Network Interface isn't ready. Shutting down.")
  else:
    print("nic:%s" % (sys.argv[1]))
    main(sys.argv[1])

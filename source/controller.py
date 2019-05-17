import cPickle
import pickle
import os,sys
import socket
import time
from collections import namedtuple
import numpy as np

start = time.time()
POWER_RESOLUTION = 2
PERFORMANCE_RESOLUTION = 0.02
MAX_POWER = 120.0
IDLE_POWER = 15.0
MIN_POWER_LIMIT = 50.0 # for power model
COMMUNICATION_FOLDER = "/exports/example/signal"

FRONTEND_HOSTS = "/home/cc/PowerShift/script/frontendHosts.txt"
BACKEND_HOSTS = "/home/cc/PowerShift/script/backendHosts.txt"
POOL_BINARY = "/home/cc/PowerShift/source/DistPwrServer.py"
LOCAL_DECIDER_BINARY = "/home/cc/PowerShift/source/DistPwrClient.py"

SERVER_HOST = str(sys.argv[4])
APP1 = str(sys.argv[1])
APP2 = str(sys.argv[2])
POWERCAP = float(sys.argv[3])
ITERATION = 8
FINISHED_ITERATION = 0
LEARN_OLD_FLAG = {APP1:0, APP2:0}

TEST=float(sys.argv[5])

# load pre-trained classifier
standardizer = pickle.load(open("/home/cc/PowerShift/tool/standardizer.sav", 'rb'))
pca = pickle.load(open("/home/cc/PowerShift/tool/pca.sav", 'rb'))
c_classifier = pickle.load(open("/home/cc/PowerShift/tool/svm-rbf-m.sav", 'rb'))
m_classifier = pickle.load(open("/home/cc/PowerShift/tool/svm-rbf-m.sav", 'rb'))

# powercap is the total power cap for both of the sockets
Configuration = namedtuple("Configuration","powerCap multiSocket hyperthread mc")

DEFAULT_CONFIGURATION = Configuration(POWERCAP, 1, 1, 1)
configurationDic1 = {}
configurationDic2 = {}
pcmDataOld ={}

class PowerModel:
    def __init__(self, idlePower, maxPower):
        self.idlePower = idlePower
        self.maxPower = maxPower
        self.powerPerfPairList = [(idlePower,0.0)]
        
    def addDataPoint(power, perf):
        self.powerPerfPairList.append((power, perf))
        self.powerPerfPairList.sort()
    
    def getPerf(power):
        # no data point
        if len(self.powerPerfPairList) == 1 :
            return -1
        # power is out of range
        if power >= self.powerPerfPairList[-1][0]:
            # linear function : y = k *x + b
            k = (self.powerPerfPairList[-1][1] - self.powerPerfPairList[-2][1]) / ((self.powerPerfPairList[-1][0] - self.powerPerfPairList[-2][0]))
            b = self.powerPerfPairList[-1][1]
            return  k * (power - self.powerPerfPairList[-1][0]) + b
        # power is in range
        lowerIndex = 0;
        upperIndex = len(self.powerPerfPairList) -1;
        for i in range(len(self.powerPerfPairList)):
            if self.powerPerfPairList[i][0] < power  and i > lowerIndex:
                lowerIndex = i
            if self.powerPerfPairList[i][0] > power  and i < upperIndex:
                upperIndex = i
        #linear model
        k = (self.powerPerfPairList[upperIndex][1] - self.powerPerfPairList[lowerIndex][1]) / ((self.powerPerfPairList[upperIndex][0] - self.powerPerfPairList[lowerIndex][0]))
        b = self.powerPerfPairList[lowerIndex][1]
        return k * (power - self.powerPerfPairList[lowerIndex][0]) + b


#run coupled application for one iteration
def runForOneIteration(config1, config2, pcmEnabled):
    if TEST:
        os.system("sleep 10")
        return
    global FINISHED_ITERATION
    FINISHED_ITERATION += 1
    args = APP1 + ' ' + str(config1[1]) + ' ' + str(config1[2]) + ' ' + str(config1[3]) + ' ' +str(config1[0]) + ' ' + APP2 + ' ' + str(config2[1]) + ' ' + str(config2[2]) + ' ' + str(config2[3]) + ' ' + str(config2[0])
    if pcmEnabled:
        # run couple with pcm enabled
        os.system("~/PowerShift/source/runAppPCM.sh "+ args)

    else:
        #runApp.sh <app1> <multi_socket1> <HT1> <MC1> <powercap1> <app2> <multi_socket2> <HT2> <MC2> <powercap2>
        os.system("~/PowerShift/source/runApp.sh "+ args)

def getFeedback(config1, config2, pcmEnabled):
    if TEST:
        os.system("sleep 10")
        return 1,0.5
    
    if (config1 in configurationDic1) and (config2 in configurationDic2):
        return configurationDic1[config1],configurationDic2[config2]
    else:
        runForOneIteration(config1, config2, pcmEnabled)
        #get perf from NFS result folder: frontend/backend
        frontendPerfFile = open("/exports/example/perf/" + APP1 + ".txt","r")
        backendPerfFile = open("/exports/example/perf/" + APP2 + ".txt","r")
        perf1 = 1 / float(frontendPerfFile.readlines()[-1])
        perf2 = 1 / float(backendPerfFile.readlines()[-1])
        frontendPerfFile.close()
        backendPerfFile.close()
        return perf1, perf2

#get pcm data
def getPCM(app):
    dirPath = "/exports/example/pcm/" + app
    numNode = 24
    pcmList = []
    for pcmFileOfEachNode in os.listdir(dirPath):
        data = np.loadtxt(pcmFileOfEachNode,skiprows=2,delimiter=";",usecols=[2,3,4,5,10,11,12,13,18,20,21])
        pcmList.append(data.mean(0))
    pcmData = np.mean(pcmList,axis = 0).tolist()
    #adding QPItoMC to the end
    pcmData.append(pcmData[-1]/(pcmData[6] + pcmData[7]))
    pcmDataOld[app] = pcmData
    return pcmData

# return resource preference by learning
def learn(app, isMC):
    pcmData = []
    if LEARN_OLD_FLAG[app]:
        pcmData = pcmDataOld[app]
    else:
        pcmData = getPCM()
    # get pcm data
    #standardization
    pcmData = standardizer.transform(pcmData)
    #pca and feature selection
    pcmData = pca.transform(pcmData)
    # feed into classifier
    if isMC:
        return m_classifier.predict(pcmData)
    else:
        return c_classifier.predict(pcmData)

#launch function for local power decider or power pool

def launch(mode, host, powerCap, id = 'None'):
    if mode == "pool":
        os.system("python " + POOL_BINARY + " " + SERVER_HOST + " &")
    else:
        os.system("ssh " + host + ' "'+ "python " + LOCAL_DECIDER_BINARY + " " + str(powerCap) + " " + SERVER_HOST + " " + id + '" &')
#write log

def logWrite(data):
    log = open("/home/cc/" + APP1 + "_" + APP2 + "_" + str(POWERCAP), "a")
    log.write(data +'\n')
    log.close()



#mark perf files
os.system("sudo echo START >> /exports/example/perf/" + str(APP1)+".txt")
os.system("sudo echo START >> /exports/example/perf/" + str(APP2)+".txt")

#start to monitoring power
os.system("/bin/bash /home/cc/PowerShift/script/startPowerMonitor.sh")

#phase 1 : classifer to find the optimal hardware config

# decide for multi socket and HT

perf1, perf2 = getFeedback(DEFAULT_CONFIGURATION, DEFAULT_CONFIGURATION, 0)
configurationDic1[DEFAULT_CONFIGURATION] = perf1
configurationDic2[DEFAULT_CONFIGURATION] = perf2

#when more applications protentially parallel the learning
#for now it's taking little time
isMultiSocketAndHT1 = learn(APP1, 0)
isMultiSocketAndHT2 = learn(APP2, 0)
curConfig1 = Configuration(POWERCAP, isMultiSocketAndHT1, isMultiSocketAndHT1, 1)
curConfig2 = Configuration(POWERCAP, isMultiSocketAndHT2, isMultiSocketAndHT2, 1)
logWrite(str(1/perf1) + ' ' + str(1/perf2) + ' ' +str(DEFAULT_CONFIGURATION[0])+ ' ' + str(DEFAULT_CONFIGURATION[0]))

# decide for MC
perf1, perf2 = getFeedback(curConfig1, curConfig2, 1)
configurationDic1[curConfig1] = perf1
configurationDic2[curConfig2] = perf2

#check whether roll back
if isMultiSocketAndHT1 == 0 and perf1 < configurationDic1[DEFAULT_CONFIGURATION]:
    #roll back for APP1
    pcmDataOld[APP1] = 1
    isMultiSocketAndHT1 = 1
    lastConfig1 = DEFAULT_CONFIGURATION
else:
    lastConfig1 = curConfig1
if isMultiSocketAndHT2 == 0 and perf2 < configurationDic2[DEFAULT_CONFIGURATION]:
    #roll back for APP2
    pcmDataOld[APP2] = 1
    isMultiSocketAndHT2 = 1
    lastConfig2 = DEFAULT_CONFIGURATION
else:
    lastConfig2 = curConfig2



IsMC1 = learn(APP1, 1)
IsMC2 = learn(APP2, 1)

curConfig1 = Configuration(POWERCAP, isMultiSocketAndHT1, isMultiSocketAndHT1, IsMC1)
curConfig2 = Configuration(POWERCAP, isMultiSocketAndHT2, isMultiSocketAndHT2, IsMC2)

logWrite(str(1/perf1) + ' ' + str(1/perf2) + ' ' +str(curConfig1[0])+ ' ' + str(curConfig2[0]))


perf1, perf2 = getFeedback(curConfig1, curConfig2, 1)
#check whether roll back
if IsMC1 == 0 and perf1 < configurationDic1[lastConfig1]:
    #roll back for APP1
    IsMC1 = 1
if IsMC2 == 0 and perf2 < configurationDic2[lastConfig2]:
    #roll back for APP2
    IsMC1 = 1

curConfig1 = Configuration(POWERCAP, isMultiSocketAndHT1, isMultiSocketAndHT1, IsMC1)
curConfig2 = Configuration(POWERCAP, isMultiSocketAndHT2, isMultiSocketAndHT2, IsMC2)

#phase 2: dynamicly building power model to decide optimal static power distribution
finalConfig1 = curConfig1
finalConfig2 = curConfig2
#initialize two power model:
pm1 = PowerModel(IDLE_POWER, MAX_POWER)
pm2 = PowerModel(IDLE_POWER, MAX_POWER)
maxShiftablePower = min(MAX_POWER - POWERCAP, POWERCAP - MIN_POWER_LIMIT)

# first iteration to find out the faster app
perf1, perf2 = getFeedback(curConfig1, curConfig2, 0)
configurationDic1[curConfig1] = perf1
configurationDic2[curConfig2] = perf2
logWrite(str(1/perf1) + ' ' + str(1/perf2) + ' ' +str(curConfig1[0])+ ' ' + str(curConfig2[0]))


reverse = 1
if perf1 < perf2:
    reverse = -1
deltaPower = maxShiftablePower / 2
deltaPerformance = abs(perf1 - perf2) / max(perf1, perf2)
print deltaPower
lastConfig1 = finalConfig1
lastConfig2 = finalConfig2

while deltaPower > POWER_RESOLUTION and deltaPerformance > PERFORMANCE_RESOLUTION:
    #LOG.write()
    #each iteration update power model and power distribution
    curConfig1 = lastConfig1._replace(powerCap = lastConfig1[0] - reverse * deltaPower)
    curConfig2 = lastConfig2._replace(powerCap = lastConfig2[0] + reverse * deltaPower)
    curPerf1, curPerf2 = getFeedback(curConfig1, curConfig2, 0)
    #FINISHED_ITERATION += 1
    #pm1.addDataPoint()
    #pm2.addDataPoint()
    configurationDic1[curConfig1] = perf1
    configurationDic2[curConfig2] = perf2
    deltaPower = deltaPower / 2.0
    deltaPerformance = abs(curPerf1 - curPerf2) / max(curPerf1, curPerf2)
    if curPerf1 > curPerf2:
        reverse = 1
    else:
        reverse = -1
    lastConfig1 = curConfig1
    lastConfig2 = curConfig2
    finalConfig1 = curConfig1
    finalConfig2 = curConfig2
    print deltaPower,deltaPerformance
    logWrite(str(1/curPerf1) + ' ' + str(1/curPerf2) + ' ' +str(curConfig1[0])+ ' ' + str(curConfig2[0]))

print "FINISHED_ITERATION before dynamic shifting phase:" + str(FINISHED_ITERATION)
#phase 3: dynamic power shiftting
print finalConfig1[0],finalConfig2[0]
logWrite('Entering dynamic phase!!!!')
#clear signal folder
os.system("sudo rm " + COMMUNICATION_FOLDER + "/*")

#launch power pool
launch("pool", "", 0)
#launch local deciders

frontendHostFile = open(FRONTEND_HOSTS, "r")
backendHostFile = open(BACKEND_HOSTS, "r")

lines1 = frontendHostFile.readlines()
lines2 = backendHostFile.readlines()
client_id =0
for line in lines1:
    launch("local decider", line.rstrip(), finalConfig1[0], str(client_id))
    client_id +=1
for line in lines2:
    launch("local decider", line.rstrip(), finalConfig2[0], str(client_id))
    client_id +=1

#run application for iterations
for i in range(ITERATION - FINISHED_ITERATION):
    runForOneIteration(finalConfig1._replace(powerCap = 0), finalConfig2._replace(powerCap = 0), 0)

#shut down

os.system("sudo touch " + COMMUNICATION_FOLDER + "/END")
end = time.time()
performance = 1.0 / (end - start)
#write results into file
result_folder= "~/PowerShift/data/powershift2.0/"+ APP1 + "_" + APP2+ "/" + str(int(POWERCAP)) +"W"
os.system("mkdir -p "+ result_folder)
result = open("/home/cc/PowerShift/data/powershift2.0/" + APP1 + "_" + APP2 + ".results","a")
result.write(str(POWERCAP) + " " + str(1/performance) + "\n")
result.close()

os.system("tail -" + str(ITERATION) + " /exports/example/perf/" + APP1 + ".txt " + ">" + result_folder + "/" + APP1 +".result")
os.system("tail -" + str(ITERATION) + " /exports/example/perf/" + APP2 + ".txt " + ">" + result_folder + "/" + APP2 +".result")

# store power data and shut down power monitor
os.system("/bin/bash /home/cc/PowerShift/script/storePowerSeries.sh " + APP1 + "_" + APP2 + "_" + str(POWERCAP) + "_" + str(start))
logWrite('END!!!!')

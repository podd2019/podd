import select
import socket
import sys,os
import Queue
import math
import time,datetime
total_extra_power=0
# 96 sockets in total
urgent_list= [0] * 96
urgent_count=0
take_power_unit=2
break_signal = 0
server_ip = str(sys.argv[1])
DEBUG_FLAG = 1
LOG_FLAG = 1
if LOG_FLAG:
    LOG_file = open("/home/cc/PowerShift/data/powershift2.0/PoolLog/"+ str(int(time.time())), 'w')

def take_power_func(TOTAL_extra_power):
    power = 0
    if TOTAL_extra_power > 10:
        power = math.floor(TOTAL_extra_power/10)
    elif TOTAL_extra_power > 300:
        power = 30
    else:
        power = 1     
    return power
# Create a TCP/IP socket
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setblocking(0)

# Bind the socket to the port
server_address = (server_ip, 10000)
if DEBUG_FLAG:
    print >>sys.stderr, 'starting up on %s port %s' % server_address
    LOG_file.write('Power Pool starting at the time:' + str(datetime.datetime.now()) + '\n')
server.bind(server_address)

# Listen for incoming connections
server.listen(50)

# Sockets from which we expect to read
inputs = [ server ]

# Sockets to which we expect to write
outputs = [ ]
# Outgoing message queues (socket:Queue)
message_queues = {}

while inputs and break_signal != 1:
    if os.path.isfile('/exports/example/signal/END'):
        break_signal = 1
        if LOG_FLAG:
            LOG_file.write('Power Pool shutting down...')

    # Wait for at least one of the sockets to be ready for processing
    if DEBUG_FLAG:
        print >>sys.stderr, '\nwaiting for the next event'
    readable, writable, exceptional = select.select(inputs, outputs, inputs)
    # Handle inputs
    for s in readable:

        if s is server:
            # A "readable" server socket is ready to accept a connection
            connection, client_address = s.accept()
            if DEBUG_FLAG:
                print >>sys.stderr, 'new connection from', client_address
            connection.setblocking(0)
            inputs.append(connection)

            # Give the connection a queue for data we want to send
            message_queues[connection] = Queue.Queue()
        else:
            data = s.recv(1024)
            if data:
                # A readable client socket has data
                receive_list = data.split(',')
                add_power =float(receive_list[0])
                urgent_flag = int(receive_list[1])
                #urgent_change = int(receive_list[2])
                client_id = int(receive_list[2])
                necessary_power =float(receive_list[3])
                take_power_unit = take_power_func(total_extra_power)
                actual_get_power = 0
                release_power = 0
                urgent_count = sum(urgent_list)

                if add_power != 0:
                    total_extra_power +=add_power
                    urgent_list[client_id] = 0
                else:
                    if urgent_flag ==1:
                        #urgent case
                        actual_get_power = min(total_extra_power, necessary_power)
                        urgent_list[client_id] = 1
                        if total_extra_power >= necessary_power:
                            urgent_list[client_id] = 0
                        total_extra_power = total_extra_power - actual_get_power
                    elif urgent_flag == 2:
                        #stable
                        actual_get_power = 0
                        urgent_list[client_id] =0
                    else:
                        urgent_list[client_id] =0
                        if urgent_count ==0:
                            actual_get_power = min(take_power_unit, total_extra_power)
                            total_extra_power -= actual_get_power
                
                if urgent_count !=0:
                    release_power = 1
                if DEBUG_FLAG:
                    print 'received_data',data,'urgent_count',urgent_count,'total_extra_power',total_extra_power

                output_data= str(actual_get_power) +','+str(release_power)
                message_queues[s].put(output_data)
                if LOG_FLAG:
                    LOG_file.write('Received: add_power = ' + str(add_power)+', urgent_flag = ' + str(urgent_flag) + ', necessary_power = ' + str(necessary_power) + '\n')
                    LOG_file.write('Sent: actual_get_power = '+ str(actual_get_power) +', release_power = '+str(release_power) + '\n')
                    LOG_file.write('Now total power in power pool: ' + str(total_extra_power) + '\n')
                # Add output channel for response
                if s not in outputs:
                    outputs.append(s)
            else:
                # Interpret empty result as closed connection
                if DEBUG_FLAG:
                    print >>sys.stderr, 'closing', client_address, 'after reading no data'
                # Stop listening for input on the connection
                if s in outputs:
                    outputs.remove(s)
                inputs.remove(s)
                s.close()
                # Remove message queue
                del message_queues[s]
    # Handle outputs
    for s in writable:
        try:
            next_msg = message_queues[s].get_nowait()
        except Queue.Empty:
            # No messages waiting so stop checking for writability.
            if DEBUG_FLAG:
                print >>sys.stderr, 'output queue for', s.getpeername(), 'is empty'
            outputs.remove(s)
        else:
            print >>sys.stderr, 'sending "%s" to %s' % (next_msg, s.getpeername())
            s.send(next_msg)
    # Handle "exceptional conditions"
    for s in exceptional:
        if DEBUG_FLAG:
            print >>sys.stderr, 'handling exceptional condition for', s.getpeername()
        # Stop listening for input on the connection
        inputs.remove(s)
        if s in outputs:
            outputs.remove(s)
        s.close()

        # Remove message queue
        del message_queues[s]

server.close()

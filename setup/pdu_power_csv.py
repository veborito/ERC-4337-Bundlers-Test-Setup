#!/usr/bin/env python3

# This is a parser for the json metrics returned by the web interface of the Lindy Ipower Control 2x6 XM
# It writes the Voltage, Current, Active Power and Power factor to a CSV file
# usage:
#       ./pdu-parser.py pdu-outputs-power.csv "http://example-pdu.url" 1
#
# hit Ctrl-C when you want to stop the capture

import argparse
import time
import json
import urllib.request
import csv

# write metrics (voltage, current, active power, power factor) for all PDU outputs
def write_outputs_metrics(timestamp, metrics_values, csv_writer):
    for output_id in range(len(metrics_values)):
        voltage = metrics_values[output_id][0]['v']
        current = metrics_values[output_id][1]['v']
        active_power = metrics_values[output_id][4]['v']
        power_factor = metrics_values[output_id][7]['v']

        csv_writer.writerow({'timestamp': timestamp, 'output-id': output_id, 'voltage': voltage, 'current': current, 'active-power': active_power, 'power-factor': power_factor})
    
    print('Values for timestamp ' + str(timestamp) + ' written to the file (took ' + str(int(time.time()) - timestamp) + ' seconds)')

# periodicaly fetch the PDU status to extract power metrics
def main(output_file, status_url, frequency):
    with open(output_file, 'w', newline='') as csvfile:
        csv_fieldnames = ['timestamp', 'output-id', 'voltage', 'current', 'active-power', 'power-factor']
        csv_writer = csv.DictWriter(csvfile, fieldnames=csv_fieldnames)
        csv_writer.writeheader()
        print('Starting PDU monitoring...')

        try:
            while True:
                timestamp = int(time.time())
                metrics = json.load(urllib.request.urlopen(status_url + '/statusjsn.js?components=16384')) # the component 16384 refer to the power sensors measurements
                write_outputs_metrics(timestamp, metrics['sensor_values'][1]['values'], csv_writer)
                time.sleep(frequency)
        except KeyboardInterrupt:
            print('PDU monitoring have been interrupted.')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("out", type=str, help="The output csv file")
    parser.add_argument("url", type=str, help="The PDU status URL")
    parser.add_argument("freq", type=int, help="The metrics refresh frequency in seconds")
    args = parser.parse_args()

    main(args.out, args.url, args.freq)

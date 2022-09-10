#!/usr/bin/python3
from sys import argv
import argparse, subprocess

def start_ping(thread_count, packages_count):
    for thread in range(thread_count) :
        try:
            subprocess.Popen(["ping","localhost","-c",f"{packages_count}"])
        except:
            print(f"Failed to start new subprocces - {thread}")

def parse_args(args):
    parser = argparse.ArgumentParser() 
    parser.add_argument('threads', help='Thread count', type=int)
    parser.add_argument('packages', help='Ping package count', type=int)
    args = parser.parse_args()
    start_ping(args.threads, args.packages)

if "__main__" == __name__ : 
    parse_args(argv[1:])
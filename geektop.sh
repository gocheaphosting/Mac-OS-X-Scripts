#!/bin/bash
ps -arcwwwxo "command %cpu %mem" | grep -v grep | head -13

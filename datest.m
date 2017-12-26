%This script is used to test the partitioning resluts of AP and DP
clear all;clc;
% load meas;
% Zk=cluttMeas(12).p; %Select time 12 for example
load data_zk;
%------distance partition--------------------------
% Zkp = partitionMeasurementSet_4(Zk,max_distance,min_distance);
%-----AP partition--------------------------------
ZkpAp=APpartitionMeasurement(Zk,max_distance,min_distance);

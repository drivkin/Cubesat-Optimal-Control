function [ c ] = BBConstraint( primal )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

c = primal.controls.^2;
end


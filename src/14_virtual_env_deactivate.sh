#!/bin/bash -x
PS4='$(date "+%s.%N ($LINENO) + ")'

#################################
# Deactivate from atmosphere's virtualenv
################################
deactivate

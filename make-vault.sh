#!/bin/bash

ansible-vault encrypt_string $1 --name $2

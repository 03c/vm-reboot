# VM-Reboot

Simple bash script to reboot a VM Super Hub 3.0

## Usage reboot.sh
- "IP - IP address of your VM router."
- "USERNAME - Username of your VM router."
- "PASSWORD - Password of your VM router."
Normally the username will be 'admin', but you can substitute if required.
```
./reboot.sh -i IP -u admin -p PASSWORD
```

## Usage check.sh
- RETRY_COUNT - Number of times to try each server for a connection.
- SERVER_COUNT - How many servers to trye (1-4).
```
./check.sh -r RETRY_COUNT -s SERVER_COUNT
```

## Thanks
Nicholas Elliott - https://github.com/JamoDevNich/SuperHub3-CLI